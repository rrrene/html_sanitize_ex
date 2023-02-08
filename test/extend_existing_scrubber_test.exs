defmodule ExtendExistingScrubberTest do
  use ExUnit.Case, async: true

  defmodule MyScrubber do
    use HtmlSanitizeEx, extend: :markdown_html

    allow_tag_with_any_attributes("p")

    allow_tag_with_uri_attributes("img", ["src"], ["data"])
    allow_tag_with_uri_attributes("img", ["src"], ["http"])
  end

  defmodule MyScrubber2 do
    use HtmlSanitizeEx, extend: ExtendExistingScrubberTest.MyScrubber
  end

  test "strips everything except the allowed tags (for multiple tags)" do
    input =
      ~S(<section><img src="data:test" /><header><script>code!</script><img src="http://example.org" /></header><p class="allowed">hello <script>code!</script></p></section>)

    expected =
      ~S(<img src="data:test" />code!<img src="http://example.org" /><p class="allowed">hello code!</p>)

    assert expected == __MODULE__.MyScrubber.sanitize(input)
  end
end
