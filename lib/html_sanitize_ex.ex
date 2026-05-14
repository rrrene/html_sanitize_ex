defmodule HtmlSanitizeEx do
  @moduledoc ~S'''
  HtmlSanitizeEx can be used to sanitize potentially malicious user input.

  It provides four convenience functions:

  - `HtmlSanitizeEx.strip_tags/1` - to simply strip all HTML tags
  - `HtmlSanitizeEx.basic_html/1` - to allow for basic HTML
  - `HtmlSanitizeEx.markdown_html/1` - to allow for a subset of HTML that is ouput by Markdown parsers
  - `HtmlSanitizeEx.html5/1` - to allow full HTML5 while scrubbing malicious elements

  These functions are shortcuts to the respective "scrubber", a module that does the sanitization.

  ### Create custom scrubbers

  HtmlSanitizeEx can be used to implement custom scrubbers:

      defmodule MyMostBasicScrubber do
        use HtmlSanitizeEx

        allow_tag_with_these_attributes("p", ["class"])
      end

  This creates a scrubber that only allows `p` tags, optionally with a `class` attribute.

      iex(1)> MyMostBasicScrubber.sanitize(
      ...(2)>   "<p class=\"success\" title=\"Success!\"><strong>Granted</strong> access!</p>")
      "<p class=\"success\">Granted access!</p>"

  ### Extend existing scrubbers

  Implementing scrubbers from scratch can be daunting, which is why HtmlSanitizeEx also supports extending existing scrubbers:

      defmodule MyScrubber do
        use HtmlSanitizeEx, extend: :basic_html

        allow_tag_with_any_attributes("p")
      end

  This creates a scrubber working exactly like `HtmlSanitizeEx.basic_html/1`, but allows `p` tags with *any* attribute.

  You can extend `:basic_html`, `:html5`, `:markdown_html` and `:strip_tags`.

  You can also extend any custom scrubber you created:

      defmodule FooBarScrubber do
        use HtmlSanitizeEx, extend: MyMostBasicScrubber

        allow_tag_with_these_attributes("p", ["title"])
      end

  This creates a scrubber that only allows `p` tags, optionally with `class` and `title` attributes.

      iex(1)> FooBarScrubber.sanitize(
      ...(2)>   "<p class=\"success\" title=\"Success!\"><strong>Granted</strong> access!</p>")
      "<p class=\"success\" title=\"Success!\">Granted access!</p>"

  '''

  alias HtmlSanitizeEx.Scrubber

  @doc false
  defmacro __using__(opts \\ []) do
    quote do
      @before_compile HtmlSanitizeEx.ScrubberCompiler
      @behaviour HtmlSanitizeEx.Scrubber

      require HtmlSanitizeEx.Scrubber.Meta
      import HtmlSanitizeEx.Scrubber.Meta

      remove_cdata_sections_before_scrub()
      strip_comments()

      def scrub_attributes(tag, attributes) do
        attributes
        |> Enum.map(&scrub_attribute(tag, &1))
        |> Enum.reject(&is_nil(&1))
      end

      defoverridable HtmlSanitizeEx.Scrubber

      unquote(extend(opts[:extend]))

      def sanitize(html) do
        HtmlSanitizeEx.Scrubber.scrub(html, __MODULE__)
      end
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

  @doc """
  Scrubs neither tags, nor their attributes.
  """
  def noscrub(html) do
    Scrubber.NoScrub.sanitize(html)
  end

  @doc """
  Allows basic HTML tags to support user input for writing relatively
  plain text but allowing headings, links, bold, and so on.

  Does not allow any styling, HTML5 tags, video embeds etc.
  """
  def basic_html(html) do
    Scrubber.BasicHTML.sanitize(html)
  end

  @doc """
  Allows all HTML5 tags to support user input.

  Sanitizes all malicious content.
  """
  def html5(html) do
    Scrubber.HTML5.sanitize(html)
  end

  @doc """
  Allows basic HTML tags to support user input for writing relatively
  plain text with Markdown (GitHub flavoured Markdown supported).

  Technically this is a more relaxed version of the BasicHTML scrubber.

  Does not allow any styling, HTML5 tags, video embeds etc.
  """
  def markdown_html(html) do
    Scrubber.MarkdownHTML.sanitize(html)
  end

  @doc """
  Strips all tags (and, naturally, attributes).
  """
  def strip_tags(html) do
    Scrubber.StripTags.sanitize(html)
  end
end
