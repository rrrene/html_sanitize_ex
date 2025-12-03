defmodule HtmlSanitizeEx.ScrubberCompiler do
  defmacro __before_compile__(env) do
    fallback_module = Module.get_attribute(env.module, :fallback_module)

    allowed_tag_names =
      Module.get_attribute(env.module, :allowed_tag_names, [])
      |> Enum.uniq()

    scrub_uri_attribute =
      Module.get_attribute(env.module, :scrub_uri_attribute, [])
      |> Enum.uniq()

    fallback_or_strip_everything =
      if fallback_module do
        quote_fallback_for_everything_not_covered(fallback_module)
      else
        quote_strip_everything_not_covered()
      end

    quote do
      unquote(quote_allow_tag_with_uri_attribute_scrubs(scrub_uri_attribute))

      unquote(quote_allowed_tag_name_scrubs(allowed_tag_names))

      unquote(fallback_or_strip_everything)
    end
  end

  defp quote_allow_tag_with_uri_attribute_scrubs([]) do
    nil
  end

  defp quote_allow_tag_with_uri_attribute_scrubs(scrub_attributes) do
    all_valid_schemes =
      scrub_attributes
      |> Enum.reduce(%{}, fn {tag_and_attr, valid_schemes}, memo ->
        Map.update(memo, tag_and_attr, valid_schemes, fn existing ->
          existing ++ valid_schemes
        end)
      end)

    defs =
      Enum.map(scrub_attributes, fn {{tag_name, attr_name}, _valid_schemes} ->
        valid_schemes = all_valid_schemes[{tag_name, attr_name}]

        quote do
          def scrub_attribute(unquote(tag_name), {unquote(attr_name), "&" <> value}) do
            nil
          end

          def scrub_attribute(unquote(tag_name), {unquote(attr_name), uri}) do
            if URI.valid_schema?(uri, unquote(valid_schemes)) do
              {unquote(attr_name), uri}
            end
          end
        end
      end)

    quote do
      alias HtmlSanitizeEx.Scrubber.URI
      unquote(defs)
    end

    # |> tap(fn q ->
    #   IO.puts("### quote_allow_tag_with_uri_attribute_scrubs ###\n")
    #   IO.puts(Code.format_string!(Macro.to_string(q)))
    # end)
  end

  defp quote_allowed_tag_name_scrubs(allowed_tag_names) do
    Enum.map(allowed_tag_names, fn tag_name ->
      quote do
        def scrub({unquote(tag_name), attributes, children}) do
          {unquote(tag_name), scrub_attributes(unquote(tag_name), attributes), children}
        end

        defp scrub_attributes(unquote(tag_name), attributes) do
          Enum.map(attributes, fn attr ->
            scrub_attribute(unquote(tag_name), attr)
          end)
          |> Enum.reject(&is_nil(&1))
        end
      end
    end)
  end

  defp quote_fallback_for_everything_not_covered(fallback_module) do
    quote do
      def before_scrub(html), do: unquote(fallback_module).before_scrub(html)

      def scrub_attribute(tag, attribute),
        do: unquote(fallback_module).scrub_attribute(tag, attribute)

      def scrub(text), do: unquote(fallback_module).scrub(text)
    end
  end

  defp quote_strip_everything_not_covered do
    replacement_linebreak = "#{HtmlSanitizeEx.Parser.replacement_for_linebreak()}"
    replacement_space = "#{HtmlSanitizeEx.Parser.replacement_for_space()}"
    replacement_tab = "#{HtmlSanitizeEx.Parser.replacement_for_tab()}"

    quote do
      # If we haven't covered the attribute until here, we just scrab it.
      def scrub_attribute("" <> _tag, _attribute) do
        nil
      end

      # If we haven't covered the attribute until here, we just scrab it.
      def scrub({"" <> _tag, _attributes, children}) do
        children
      end

      def scrub({"" <> _tag, children}), do: children

      def scrub(unquote(" " <> replacement_linebreak <> " ") <> text), do: text

      def scrub(unquote(" " <> replacement_space <> " ") <> text),
        do: " " <> text

      def scrub(unquote(" " <> replacement_tab <> " ") <> text), do: text

      # Text is left alone
      def scrub("" <> text), do: text
    end
  end
end
