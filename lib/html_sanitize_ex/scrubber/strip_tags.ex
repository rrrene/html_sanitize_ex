defmodule HtmlSanitizeEx.Scrubber.StripTags do
  @moduledoc """
  Strips all tags.
  """

  use HtmlSanitizeEx.Scrubber

  # Removes any CDATA tags before the traverser/scrubber runs.
  remove_cdata_sections_before_scrub()

  strip_comments()

  strip_everything_not_covered()
end
