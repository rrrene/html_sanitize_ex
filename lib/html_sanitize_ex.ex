defmodule HtmlSanitizeEx do
  alias HtmlSanitizeEx.Scrubber

  def noscrub(html) do
    Scrubber.scrub(html, Scrubber.NoScrub)
  end

  def basic_html(html) do
    Scrubber.scrub(html, Scrubber.BasicHTML)
  end

  def html5(html) do
    Scrubber.scrub(html, Scrubber.HTML5)
  end

  def markdown_html(html) do
    Scrubber.scrub(html, Scrubber.MarkdownHTML)
  end

  def strip_tags(html) do
    Scrubber.scrub(html, Scrubber.StripTags)
  end
end
