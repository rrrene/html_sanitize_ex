defmodule HtmlSanitizeEx.Scrubber do
  @moduledoc """
  The Scrubber module can be used to implement custom scrubbers:
  from scratch or by extending an existing scrubber.


      defmodule MyScrubber do
        use HtmlSanitizeEx.Scrubber, extend: :basic_html

        allow_tag_with_any_attributes("p")
      end

  You can extend `:basic_html`, `:html5`, `:markdown_html` and `:strip_tags` as well as any custom scrubber you created:

      defmodule FooBarScrubber do
        use HtmlSanitizeEx.Scrubber, extend: MyScrubber

        allow_tag_with_any_attributes("header")
      end

  """

  @doc false
  defmacro __using__(opts \\ []) do
    quote do
      @before_compile HtmlSanitizeEx.ScrubberCompiler

      require HtmlSanitizeEx.Scrubber.Meta
      import HtmlSanitizeEx.Scrubber.Meta

      unquote(extend(opts[:extend]))
    end
  end

  defp extend(:noscrub), do: extend(HtmlSanitizeEx.Scrubber.NoScrub)
  defp extend(:basic_html), do: extend(HtmlSanitizeEx.Scrubber.BasicHTML)
  defp extend(:html5), do: extend(HtmlSanitizeEx.Scrubber.HTML5)
  defp extend(:markdown_html), do: extend(HtmlSanitizeEx.Scrubber.MarkdownHTML)
  defp extend(:strip_tags), do: extend(HtmlSanitizeEx.Scrubber.StripTags)

  defp extend(mod) do
    quote do
      @fallback_module unquote(mod)
    end
  end

  #
  #

  def scrub(html, scrubber_module)

  def scrub("", _) do
    ""
  end

  def scrub(nil, _) do
    ""
  end

  def scrub(html, scrubber_module) do
    html
    |> scrubber_module.before_scrub
    |> HtmlSanitizeEx.Parser.parse()
    |> HtmlSanitizeEx.Traverser.traverse(scrubber_module)
    |> HtmlSanitizeEx.Parser.to_html()
  end
end
