defmodule CustomScrubberTest do
  use ExUnit.Case, async: true

  defmodule Custom do
    require HtmlSanitizeEx.Scrubber.Meta
    alias HtmlSanitizeEx.Scrubber.Meta

    # Removes any CDATA tags before the traverser/scrubber runs.
    Meta.remove_cdata_sections_before_scrub()

    Meta.strip_comments()

    Meta.allow_tag_with_any_attributes("p")

    Meta.allow_tags_with_style_attributes(["span", "header"])
    Meta.allow_tag_with_uri_attributes("a", ["href"], ["http", "https"])
    Meta.allow_tags_and_scrub_their_attributes(["a", "span", "header"])

    Meta.strip_everything_not_covered()
  end

  defp scrub(text) do
    HtmlSanitizeEx.Scrubber.scrub(text, __MODULE__.Custom)
  end

  test "strips everything except the allowed tags (for multiple tags)" do
    input =
      ~S(<section><header style="font-weight: bold"><script>code!</script></header>
          <p><span style="font-weight: bold; font-style: italic">hello</span><script>code!</script></p></section>)

    expected = ~S(<header style="font-weight: bold">code!</header>
          <p><span style="font-weight: bold; font-style: italic">hello</span>code!</p>)
    assert expected == scrub(input)
  end

  test "accepts URI" do
    input = ~S(<p><a href="abcd.com">World</a></p>)

    expected = ~S(<p><a href="abcd.com">World</a></p>)
    assert expected == scrub(input)
  end
end
