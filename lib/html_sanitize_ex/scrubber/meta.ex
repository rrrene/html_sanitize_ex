defmodule HtmlSanitizeEx.Scrubber.Meta do
  @moduledoc """
  This module contains some meta-programming magic to define your own rules
  for scrubbers.

  The StripTags scrubber is a good starting point:

      defmodule HtmlSanitizeEx.Scrubber.StripTags do
        require HtmlSanitizeEx.Scrubber.Meta
        alias HtmlSanitizeEx.Scrubber.Meta

        # Removes any CDATA tags before the traverser/scrubber runs.
        Meta.remove_cdata_sections_before_scrub

        Meta.strip_comments

        Meta.strip_everything_not_covered
      end

  You can use the `allow_tag_with_uri_attributes/3` and
  `allow_tag_with_these_attributes/2` macros to define what is allowed:

      defmodule HtmlSanitizeEx.Scrubber.StripTags do
        require HtmlSanitizeEx.Scrubber.Meta
        alias HtmlSanitizeEx.Scrubber.Meta

        # Removes any CDATA tags before the traverser/scrubber runs.
        Meta.remove_cdata_sections_before_scrub

        Meta.strip_comments

        Meta.allow_tag_with_uri_attributes   "img", ["src"], ["http", "https"]
        Meta.allow_tag_with_these_attributes "img", ["width", "height"]

        Meta.strip_everything_not_covered
      end

  You can stack these if convenient:

      Meta.allow_tag_with_uri_attributes   "img", ["src"], ["http", "https"]
      Meta.allow_tag_with_these_attributes "img", ["width", "height"]
      Meta.allow_tag_with_these_attributes "img", ["title", "alt"]

  """

  @doc """
  Allow these tags and use the regular `scrub_attribute/2` function to scrub
  the attributes.
  """
  defmacro allow_tags_and_scrub_their_attributes(list) do
    Enum.map(list, fn tag_name -> allow_this_tag_and_scrub_its_attributes(tag_name) end)
  end

  @doc """
  Allow the given +list+ of attributes for the specified +tag+.

      Meta.allow_tag_with_these_attributes "a", ["name", "title"]

      Meta.allow_tag_with_these_attributes "img", ["title", "alt"]
  """
  defmacro allow_tag_with_these_attributes(tag_name, list \\ []) do
    list
    |> Enum.map(fn attr_name -> allow_this_tag_with_this_attribute(tag_name, attr_name) end)
    |> Enum.concat([allow_this_tag_and_scrub_its_attributes(tag_name)])
  end

  @doc """
  Allow the given list of +values+ for the given +attribute+ on the
  specified +tag+.

      Meta.allow_tag_with_this_attribute_values "a", "target", ["_blank"]
  """
  defmacro allow_tag_with_this_attribute_values(tag_name, attribute, values) do
    quote do
      def scrub_attribute(unquote(tag_name), {unquote(attribute), value})
          when value in unquote(values) do
        {unquote(attribute), value}
      end
    end
  end

  @doc """
  Allow the given +list+ of attributes to contain URI information for the
  specified +tag+.

      # Only allow SSL-enabled and mailto links
      Meta.allow_tag_with_uri_attributes "a", ["href"], ["https", "mailto"]

      # Only allow none-SSL images
      Meta.allow_tag_with_uri_attributes "img", ["src"], ["http"]
  """
  defmacro allow_tag_with_uri_attributes(tag, list, valid_schemes) do
    list
    |> Enum.map(fn name -> allow_tag_with_uri_attribute(tag, name, valid_schemes) end)
  end

  @doc """

  """
  defmacro allow_tags_with_style_attributes(list) do
    list
    |> Enum.map(fn tag_name -> allow_this_tag_with_style_attribute(tag_name) end)
  end

  @doc """
  Removes any CDATA tags before the traverser/scrubber runs.
  """
  defmacro remove_cdata_sections_before_scrub do
    quote do
      def before_scrub(html), do: String.replace(html, "<![CDATA[", "")
    end
  end

  @doc """
  Strips all comments.
  """
  defmacro strip_comments do
    quote do
      def scrub({:comment, children}), do: ""
    end
  end

  @doc """
  Ensures any tags/attributes not explicitly whitelisted until this
  statement are stripped.
  """
  defmacro strip_everything_not_covered do
    replacement_linebreak = "#{HtmlSanitizeEx.Parser.replacement_for_linebreak}"
    replacement_space = "#{HtmlSanitizeEx.Parser.replacement_for_space}"
    replacement_tab = "#{HtmlSanitizeEx.Parser.replacement_for_tab}"

    quote do
      # If we haven't covered the attribute until here, we just scrab it.
      def scrub_attribute(_tag, _attribute), do: nil

      # If we haven't covered the attribute until here, we just scrab it.
      def scrub({_tag, _attributes, children}), do: children

      def scrub({_tag, children}), do: children

      def scrub(unquote(" " <> replacement_linebreak <> " ") <> text), do: text
      def scrub(unquote(" " <> replacement_space <> " ") <> text), do: " " <> text
      def scrub(unquote(" " <> replacement_tab <> " ") <> text), do: text

      # Text is left alone
      def scrub("" <> text), do: text
    end
  end



  defp allow_this_tag_and_scrub_its_attributes(tag_name) do
    quote do
      def scrub({unquote(tag_name), attributes, children}) do
        {unquote(tag_name), scrub_attributes(unquote(tag_name), attributes), children}
      end

      defp scrub_attributes(unquote(tag_name), attributes) do
        Enum.map(attributes, fn(attr) -> scrub_attribute(unquote(tag_name), attr) end)
        |> Enum.reject(&(is_nil(&1)))
      end
    end
  end

  defp allow_this_tag_with_this_attribute(tag_name, attr_name) do
    quote do
      def scrub_attribute(unquote(tag_name), {unquote(attr_name), value}) do
        {unquote(attr_name), value}
      end
    end
  end

  defp allow_this_tag_with_style_attribute(tag_name) do
    quote do
      def scrub_attribute(unquote(tag_name), {"style", value}) do
        {"style", scrub_css(value)}
      end
    end
  end

  defp allow_tag_with_uri_attribute(tag_name, attr_name, valid_schemes) do
    quote do
      def scrub_attribute(unquote(tag_name), {unquote(attr_name), "&" <> value}) do
        nil
      end

      @protocol_separator ~r/:|(&#0*58)|(&#x70)|(&#x0*3a)|(%|&#37;)3A/mi
      @scheme_capture ~r/(.+?)(:|(&#0*58)|(&#x70)|(&#x0*3a)|(%|&#37;)3A)/mi

      def scrub_attribute(unquote(tag_name), {unquote(attr_name), uri}) do
        valid_schema = if String.match?(uri, @protocol_separator) do
          case Regex.run(@scheme_capture, uri) do
            [_, scheme, _] ->
              Enum.any?(unquote(valid_schemes), fn x -> x == scheme end)
            nil ->
              false
          end
        else
          true
        end
        if valid_schema, do: {unquote(attr_name), uri}
      end
    end
  end
end
