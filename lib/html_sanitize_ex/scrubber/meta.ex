defmodule HtmlSanitizeEx.Scrubber.Meta do
  @doc "Allow these tags and use the regular `scrub_attribute/2` function to scrub the attributes."
  defmacro allow_tags_and_scrub_its_attributes(list) do
    Enum.map(list, fn name -> allow_this_tag_and_scrub_its_attributes(name) end)
  end

  @doc "Allow these tags if they don't have attributes"
  defmacro allow_tag_with_these_attributes(tag, list) do
    Enum.map(list, fn name -> allow_this_tag_with_these_attributes(tag, name) end)
  end

  @doc "Allow these tags if they don't have attributes"
  defmacro allow_these_tags_without_attributes(list) do
    Enum.map(list, fn name -> allow_these_tag_without_attributes(name) end)
  end

  defp allow_this_tag_and_scrub_its_attributes(name) do
    quote do
      def scrub({unquote(name), attributes, children}) do
        {unquote(name), scrub_attributes(unquote(name), attributes), children}
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

  defp allow_these_tag_without_attributes(name) do
    quote do
      def scrub({unquote(name), [], children}) do
        {unquote(name), [], children}
      end
    end
  end
end
