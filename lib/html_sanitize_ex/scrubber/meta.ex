defmodule HtmlSanitizeEx.Scrubber.Meta do
  @moduledoc """
  This module contains some meta-programming magic to define your own rules
  for scrubbers.

  The StripTags scrubber is a good starting point:

      defmodule MyStripTags do
        require HtmlSanitizeEx.Scrubber.Meta
        alias HtmlSanitizeEx.Scrubber.Meta

        # Removes any CDATA tags before the traverser/scrubber runs.
        Meta.remove_cdata_sections_before_scrub

        Meta.strip_comments

        Meta.strip_everything_not_covered
      end

  You can use the `allow_tag_with_uri_attributes/3` and
  `allow_tag_with_these_attributes/2` macros to define what is allowed:

      defmodule MyStripTags do
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

  # defmacro allow_tags_and_scrub_their_attributes(list)
  # defmacro allow_tag_with_these_attributes(tag_name, list \\ [])
  # defmacro allow_tag_with_any_attributes(tag_name)
  # defmacro allow_tag_with_this_attribute_values(tag_name, attribute, values)
  # defmacro allow_tag_with_uri_attributes(tag_name, list, valid_schemes)
  # defmacro allow_tags_with_style_attributes(list)

  # defmacro remove_cdata_sections_before_scrub
  # defmacro strip_comments
  # defmacro strip_everything_not_covered

  @doc """
  Allow these tags and use the regular `scrub_attribute/2` function to scrub
  the attributes.
  """
  defmacro allow_tags_and_scrub_their_attributes(list) do
    Enum.map(list, &allow_this_tag_and_scrub_its_attributes/1)
  end

  @doc """
  Allow the given +list+ of attributes for the specified +tag+.

      Meta.allow_tag_with_these_attributes "a", ["name", "title"]

      Meta.allow_tag_with_these_attributes "img", ["title", "alt"]
  """
  defmacro allow_tag_with_these_attributes(tag_name, list \\ []) do
    list
    |> Enum.map(&allow_this_tag_with_this_attribute(tag_name, &1))
    |> Enum.concat([allow_this_tag_and_scrub_its_attributes(tag_name)])
  end

  @doc """
  Allow any attributes for the specified +tag+.

      Meta.allow_tag_with_any_attributes "a"

      Meta.allow_tag_with_any_attributes "img"
  """
  defmacro allow_tag_with_any_attributes(tag_name) do
    quote do
      def scrub_attribute(unquote(tag_name), {attr_name, value}) do
        {attr_name, value}
      end

      unquote(allow_this_tag_and_scrub_its_attributes(tag_name))
    end
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
  defmacro allow_tag_with_uri_attributes(tag_name, list, valid_schemes) do
    quotes =
      Enum.map(list, &allow_tag_with_uri_attribute(tag_name, &1, valid_schemes))

    # |> tap(fn q ->
    #   IO.puts("### allow_tag_with_uri_attributes ###\n")
    #   IO.puts(Code.format_string!(Macro.to_string(q)))
    # end)

    [allow_this_tag_and_scrub_its_attributes(tag_name)] ++ quotes
  end

  @doc false
  defmacro allow_tags_with_style_attributes(list) do
    Enum.map(list, &allow_this_tag_with_style_attribute/1)
  end

  @doc """
  Removes any CDATA tags before the traverser/scrubber runs.
  """
  defmacro remove_cdata_sections_before_scrub do
    quote do
      def before_scrub("" <> html), do: String.replace(html, "<![CDATA[", "")
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
  @deprecated ""
  defmacro strip_everything_not_covered do
    __add__before_compile_for_legacy_support__()
  end

  defp allow_this_tag_and_scrub_its_attributes(tag_name) do
    quote do
      Module.register_attribute(
        __MODULE__,
        :allowed_tag_names,
        accumulate: true
      )

      @allowed_tag_names unquote(tag_name)
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
      Module.register_attribute(
        __MODULE__,
        :scrub_uri_attribute,
        accumulate: true
      )

      @scrub_uri_attribute {{unquote(tag_name), unquote(attr_name)},
                            unquote(valid_schemes)}
    end
  end

  defp __add__before_compile_for_legacy_support__ do
    quote do
      @before_compile HtmlSanitizeEx.ScrubberCompiler
    end
  end
end
