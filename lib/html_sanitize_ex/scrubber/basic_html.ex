defmodule HtmlSanitizeEx.Scrubber.BasicHTML do
  @moduledoc """
  Allows basic HTML tags to support user input for writing relatively
  plain text with e.g. Markdown.

  Does not allow any mailto-links, styling, HTML5 tags, video embeds etc.
  """

  require HtmlSanitizeEx.Scrubber.Meta
  alias HtmlSanitizeEx.Scrubber.Meta

  # Removes any CDATA tags before the traverser/scrubber runs.
  Meta.remove_cdata_sections_before_scrub

  Meta.strip_comments

  # Tags allowed without attributes (they are scrubbed)
  Meta.allow_tags_and_scrub_their_attributes ["h1", "h2", "h3", "h4", "h5",
                  "a", "b", "blockquote", "br", "code", "del", "em", "hr", "i",
                  "img", "li", "ol", "ul", "p", "pre", "span", "strong", "u",
                  "table", "tbody", "td", "th", "thead", "tr"]

  @valid_schemes ["http", "https"]

  # <A>
  Meta.allow_tag_with_uri_attributes   "a", ["href"], @valid_schemes
  Meta.allow_tag_with_these_attributes "a", ["name", "title"]

  # <IMG>
  Meta.allow_tag_with_uri_attributes   "img", ["src"], @valid_schemes
  Meta.allow_tag_with_these_attributes "img", ["width", "height", "title", "alt"]

  Meta.strip_everything_not_covered
end
