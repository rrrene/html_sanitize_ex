defmodule CustomLegacyScrubberTest do
  use ExUnit.Case, async: true

  import HtmlSanitizeEx.Scrubber

  defmodule CustomLegacy0 do
    require HtmlSanitizeEx.Scrubber.Meta
    alias HtmlSanitizeEx.Scrubber.Meta

    Meta.remove_cdata_sections_before_scrub()

    Meta.strip_everything_not_covered()
  end

  test "strips everything except the allowed tags /0" do
    input =
      ~S(<section><header><script>code!</script></header><p class="allowed">hello <script>code!</script></p></section>)

    expected = ~S(code!hello code!)
    assert expected == scrub(input, __MODULE__.CustomLegacy0)
  end

  defmodule CustomLegacy1 do
    require HtmlSanitizeEx.Scrubber.Meta
    alias HtmlSanitizeEx.Scrubber.Meta

    Meta.remove_cdata_sections_before_scrub()

    Meta.strip_comments()

    Meta.allow_tag_with_any_attributes("p")

    Meta.strip_everything_not_covered()
  end

  test "strips everything except the allowed tags /1" do
    input =
      ~S(<section><header><script>code!</script></header><p class="allowed">hello <script>code!</script></p></section>)

    expected = ~S(code!<p class="allowed">hello code!</p>)
    assert expected == scrub(input, __MODULE__.CustomLegacy1)
  end

  defmodule CustomLegacy2 do
    require HtmlSanitizeEx.Scrubber.Meta
    alias HtmlSanitizeEx.Scrubber.Meta

    Meta.remove_cdata_sections_before_scrub()

    Meta.strip_comments()

    Meta.allow_tag_with_uri_attributes("img", ["src"], ["http", "https"])

    Meta.allow_tag_with_these_attributes("p", ["style"])

    Meta.allow_tag_with_these_attributes("img", ["width", "height"])

    Meta.allow_tag_with_these_attributes("p", ["class"])

    Meta.allow_tag_with_these_attributes("img", ["title", "alt"])

    Meta.strip_everything_not_covered()
  end

  test "strips everything except the allowed tags /2" do
    input =
      ~S(<section><header><script>code!</script></header><p class="allowed">hello <script>code!</script></p></section>)

    expected = ~S(code!<p class="allowed">hello code!</p>)
    assert expected == scrub(input, __MODULE__.CustomLegacy2)
  end

  defmodule LinksOnlyScrubber do
    require HtmlSanitizeEx.Scrubber.Meta
    alias HtmlSanitizeEx.Scrubber.Meta

    Meta.remove_cdata_sections_before_scrub()
    Meta.strip_comments()

    Meta.allow_tag_with_uri_attributes("a", ["href"], ["https", "mailto", "http"])

    Meta.strip_everything_not_covered()
  end

  test "strips everything except the allowed tags from #62" do
    input = "This is a <a href=\"https://www.youtube.com/\">test</a>"

    assert input == scrub(input, __MODULE__.LinksOnlyScrubber)
  end

  defmodule MyScrubber do
    require HtmlSanitizeEx.Scrubber.Meta
    alias HtmlSanitizeEx.Scrubber.Meta

    Meta.remove_cdata_sections_before_scrub()
    Meta.strip_comments()

    Meta.allow_tag_with_these_attributes("img", [])

    def scrub_attribute("img", {"src", "data:" <> _ = uri}) do
      {"src", uri}
    end

    Meta.allow_tag_with_uri_attributes(
      "img",
      ["src"],
      ["http", "https", "mailto", "data"]
    )

    Meta.strip_everything_not_covered()
  end

  test "strips everything except the allowed tags from #65" do
    input =
      ~s|<img src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==" onload="malware()" />|

    expected =
      ~s|<img src="data:image/png;base64, iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==" />|

    assert expected == scrub(input, __MODULE__.MyScrubber)
  end
end
