defmodule CustomScrubberTest do
  use ExUnit.Case, async: true

  defmodule Custom do
    require HtmlSanitizeEx.Scrubber.Meta
    alias HtmlSanitizeEx.Scrubber.Meta

    # Removes any CDATA tags before the traverser/scrubber runs.
    Meta.remove_cdata_sections_before_scrub()

    Meta.strip_comments()

    Meta.allow_tag_with_any_attributes("p")

    Meta.strip_everything_not_covered()
  end

  defp scrub(text) do
    HtmlSanitizeEx.Scrubber.scrub(text, __MODULE__.Custom)
  end

  test "strips everything except the allowed tags (for multiple tags)" do
    input =
      "<section><header><script>code!</script></header><p>hello <script>code!</script></p></section>"

    expected = "code!<p>hello code!</p>"
    assert expected == scrub(input)
  end
end
