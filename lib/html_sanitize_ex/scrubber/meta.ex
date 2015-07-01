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
    Enum.map(list, fn name -> allow_this_tag_and_scrub_its_attributes(name) end)
  end

  @doc """
    Allow the given +list+ of attributes for the specified +tag+.

        Meta.allow_tag_with_these_attributes "a", ["name", "title"]

        Meta.allow_tag_with_these_attributes "img", ["title", "alt"]

  """
  defmacro allow_tag_with_these_attributes(tag, list) do
    Enum.map(list, fn name -> allow_this_tag_with_these_attributes(tag, name) end)
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
    Enum.map(list, fn name -> allow_tag_with_uri_attribute(tag, name, valid_schemes) end)
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
    quote do
      # If we haven't covered the attribute until here, we just scrab it.
      def scrub_attribute(_tag, _attribute), do: nil

      # If we haven't covered the attribute until here, we just scrab it.
      def scrub({_tag, _attributes, children}), do: children
      def scrub({_tag, children}), do: children

      # Text is left alone
      def scrub(text), do: text
    end
  end



  defp allow_this_tag_and_scrub_its_attributes(name) do
    quote do
      def scrub({unquote(name), attributes, children}) do
        {unquote(name), scrub_attributes(unquote(name), attributes), children}
      end

      defp scrub_attributes(tag, attributes) do
        Enum.map(attributes, fn(attr) -> scrub_attribute(tag, attr) end)
          |> Enum.reject(&(is_nil(&1)))
      end
    end
  end

  defp allow_this_tag_with_these_attributes(name, attr_name) do
    quote do
      def scrub_attribute(unquote(name), {unquote(attr_name), value}) do
        {unquote(attr_name), value}
      end
    end
  end

  defp allow_tag_with_uri_attribute(name, attr_name, valid_schemes) do
    quote do
      def scrub_attribute(unquote(name), {unquote(attr_name), "&" <> value}) do
        nil
      end

      @protocol_separator ~r/:|(&#0*58)|(&#x70)|(&#x0*3a)|(%|&#37;)3A/mi
      @scheme_capture ~r/(.+?)(:|(&#0*58)|(&#x70)|(&#x0*3a)|(%|&#37;)3A)/mi

      def scrub_attribute(unquote(name), {unquote(attr_name), uri}) do
        valid_schema = false
        if String.match?(uri, @protocol_separator) do
          valid_schema = case Regex.run(@scheme_capture, uri) do
            [_, scheme, _] ->
              Enum.any?(unquote(valid_schemes), fn x -> x == scheme end)
            nil ->
              false
          end
        else
          valid_schema = true
        end
        if valid_schema, do: {unquote(attr_name), uri}
      end
    end
  end
end
