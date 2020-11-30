# defmodule HtmlSanitizeEx.Scrubber.CustomConfig do
#   @moduledoc """
#   Allows tags from custom config
#   """

#   require HtmlSanitizeEx.Scrubber.Meta
#   alias HtmlSanitizeEx.Scrubber.Meta

#   Meta.remove_cdata_sections_before_scrub()

#   Meta.strip_comments()

#   Meta.allow_list_of_tags_with_uri_attributes(
#     :html_sanitize_ex,
#     :html_sanitize_ex,
#     :list_of_tags_with_uri_attributes
#   )

#   Meta.allow_list_of_tags_with_these_attributes(
#     :html_sanitize_ex,
#     :html_sanitize_ex,
#     :list_of_tags_with_these_attributes
#   )

#   Meta.strip_everything_not_covered()
# end
