defmodule CustomLegacyScrubberTest do
  use ExUnit.Case, async: true

  import HtmlSanitizeEx.Scrubber

  defmodule Custom1 do
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
    assert expected == scrub(input, __MODULE__.Custom1)
  end

  defmodule Custom2 do
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
    assert expected == scrub(input, __MODULE__.Custom2)
  end
end
