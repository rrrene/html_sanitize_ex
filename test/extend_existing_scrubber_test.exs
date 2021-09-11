defmodule ExtendExistingScrubberTest do
  use ExUnit.Case, async: true

  defmodule MyScrubber do
    # - allow additional tags
    # - allow additional attributes
    # - allow additional attribute restrictions (e.g. URI schemes for anchors and images)

    use HtmlSanitizeEx.Scrubber

    extend(HtmlSanitizeEx.Scrubber.MarkdownHTML)

    allow_tag_with_any_attributes("p")

    allow_tag_with_uri_attributes("img", ["src"], ["data"])

    strip_everything_not_covered()
  end

  defp scrub(text) do
    HtmlSanitizeEx.Scrubber.scrub(text, __MODULE__.MyScrubber)
  end

  test "strips everything except the allowed tags (for multiple tags)" do
    input =
      ~S(<section><img src="data:test" /><header><script>code!</script><img src="test.jpg" /></header><p class="allowed">hello <script>code!</script></p></section>)

    expected =
      ~S(<img src="data:test" />code!<img src="test.jpg" /><p class="allowed">hello code!</p>)

    assert expected == scrub(input)
  end
end
