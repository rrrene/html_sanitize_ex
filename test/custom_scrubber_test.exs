defmodule CustomScrubberTest do
  use ExUnit.Case, async: true

  defmodule Custom1 do
    use HtmlSanitizeEx, extend: :strip_tags

<<<<<<< HEAD
    allow_tag_with_any_attributes("p")
=======
    # Removes any CDATA tags before the traverser/scrubber runs.
    Meta.remove_cdata_sections_before_scrub()

    Meta.strip_comments()

    Meta.allow_tag_with_any_attributes("p")

    Meta.allow_tags_with_style_attributes(["span", "html", "body"])

    Meta.strip_everything_not_covered()
  end

  defp scrub(text) do
    HtmlSanitizeEx.Scrubber.scrub(text, __MODULE__.Custom)
>>>>>>> master
  end

  test "strips everything except the allowed tags (for multiple tags)" do
    input =
      ~S(<section><header><script>code!</script></header><p class="allowed">hello <script>code!</script></p></section>)

    expected = ~S(code!<p class="allowed">hello code!</p>)
    assert expected == Custom1.sanitize(input)
  end
end
