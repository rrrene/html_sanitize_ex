defmodule HtmlSanitizeEx do
  @moduledoc """
  HtmlSanitizeEx can be used to implement custom scrubbers, from scratch or by extending an existing scrubber.

      defmodule MyScrubber do
        use HtmlSanitizeEx, extend: :basic_html

        allow_tag_with_any_attributes("p")
      end

  You can extend `:basic_html`, `:html5`, `:markdown_html` and `:strip_tags`.

  You can also extend any custom scrubber you created:

      defmodule FooBarScrubber do
        use HtmlSanitizeEx, extend: MyScrubber

        allow_tag_with_any_attributes("header")
      end

  """

  alias HtmlSanitizeEx.Scrubber

  @doc false
  defmacro __using__(opts \\ []) do
    quote do
      @before_compile HtmlSanitizeEx.ScrubberCompiler

      require HtmlSanitizeEx.Scrubber.Meta
      import HtmlSanitizeEx.Scrubber.Meta

      unquote(extend(opts[:extend]))

      def sanitize(html), do: HtmlSanitizeEx.Scrubber.scrub(html, __MODULE__)
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

  def noscrub(html) do
    Scrubber.NoScrub.sanitize(html)
  end

  def basic_html(html) do
    Scrubber.BasicHTML.sanitize(html)
  end

  def html5(html) do
    Scrubber.HTML5.sanitize(html)
  end

  def markdown_html(html) do
    Scrubber.MarkdownHTML.sanitize(html)
  end

  def strip_tags(html) do
    Scrubber.StripTags.sanitize(html)
  end
end
