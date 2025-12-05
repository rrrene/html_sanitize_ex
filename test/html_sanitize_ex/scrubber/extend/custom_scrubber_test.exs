defmodule CustomScrubberTest do
  use ExUnit.Case, async: true

  defmodule Custom1 do
    use HtmlSanitizeEx, extend: :strip_tags

    allow_tag_with_any_attributes("p")
  end

  test "strips everything except the allowed tags (for multiple tags)" do
    input =
      ~S(<section><header><script>code!</script></header><p class="allowed">hello <script>code!</script></p></section>)

    expected = ~S(code!<p class="allowed">hello code!</p>)
    assert expected == Custom1.sanitize(input)
  end
end
