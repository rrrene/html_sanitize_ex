defmodule HtmlSanitizeEx do
  alias HtmlSanitizeEx.Scrubber

  def noscrub(html) do
    html |> Scrubber.scrub(Scrubber.NoScrub)
  end

  def basic_html(html) do
    html |> Scrubber.scrub(Scrubber.BasicHTML)
  end

  def html5(html) do
    html |> Scrubber.scrub(Scrubber.HTML5)
  end

  def markdown_html(html) do
    html |> Scrubber.scrub(Scrubber.MarkdownHTML)
  end

  def strip_tags(html) do
    html |> Scrubber.scrub(Scrubber.StripTags)
  end
end
