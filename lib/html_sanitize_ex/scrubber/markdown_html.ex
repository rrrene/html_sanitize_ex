defmodule HtmlSanitizeEx.Scrubber.MarkdownHTML do
  @moduledoc """
  Allows basic HTML tags to support user input for writing relatively
  plain text with Markdown (GitHub flavoured Markdown supported).

  Technically this is a more relaxed version of the BasicHTML scrubber.

  Does not allow any mailto-links, styling, HTML5 tags, video embeds etc.
  """

  use HtmlSanitizeEx.Scrubber

  # Removes any CDATA tags before the traverser/scrubber runs.
  remove_cdata_sections_before_scrub()

  strip_comments()

  allow_tag_with_uri_attributes("a", ["href"], ["http", "https", "mailto"])
  allow_tag_with_these_attributes("a", ["name", "title"])

  allow_tag_with_this_attribute_values("a", "target", ["_blank"])

  allow_tag_with_this_attribute_values("a", "rel", [
    "noopener",
    "noreferrer"
  ])

  allow_tag_with_these_attributes("b", [])
  allow_tag_with_these_attributes("blockquote", [])
  allow_tag_with_these_attributes("br", [])
  allow_tag_with_these_attributes("code", ["class"])
  allow_tag_with_these_attributes("del", [])
  allow_tag_with_these_attributes("em", [])
  allow_tag_with_these_attributes("h1", [])
  allow_tag_with_these_attributes("h2", [])
  allow_tag_with_these_attributes("h3", [])
  allow_tag_with_these_attributes("h4", [])
  allow_tag_with_these_attributes("h5", [])
  allow_tag_with_these_attributes("h6", [])
  allow_tag_with_these_attributes("hr", [])
  allow_tag_with_these_attributes("i", [])

  allow_tag_with_uri_attributes("img", ["src"], ["http", "https"])

  allow_tag_with_these_attributes("img", [
    "width",
    "height",
    "title",
    "alt"
  ])

  allow_tag_with_these_attributes("li", [])
  allow_tag_with_these_attributes("ol", [])
  allow_tag_with_these_attributes("p", [])
  allow_tag_with_these_attributes("pre", [])
  allow_tag_with_these_attributes("span", [])
  allow_tag_with_these_attributes("strong", [])
  allow_tag_with_these_attributes("table", [])
  allow_tag_with_these_attributes("tbody", [])
  allow_tag_with_these_attributes("td", [])
  allow_tag_with_these_attributes("th", [])
  allow_tag_with_these_attributes("thead", [])
  allow_tag_with_these_attributes("tr", [])
  allow_tag_with_these_attributes("u", [])
  allow_tag_with_these_attributes("ul", [])

  strip_everything_not_covered()
end
