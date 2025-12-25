defmodule CustomScrubberTest do
  use ExUnit.Case, async: true

  defmodule Custom0 do
    use HtmlSanitizeEx
  end

  test "strips some things except the allowed tags (for multiple tags)" do
    input =
      ~S(<section><header><script>code!</script></header><p class="allowed">hello <script>code!</script></p></section>)

    expected = ~S(code!hello code!)
    assert expected == Custom0.sanitize(input)
  end

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

  defmodule Custom2 do
    use HtmlSanitizeEx, extend: :strip_tags

    allow_tag_with_these_attributes("p", ["title"]) do
      {"class", value} when value in ["red", "green", "blue"] ->
        {"class", value}
    end
  end

  test "it strips the not allowed class from <p>" do
    input =
      ~S(<section><p class="not-allowed">hello <script>code!</script></p></section>)

    expected = ~S(<p>hello code!</p>)
    assert expected == Custom2.sanitize(input)
  end

  test "it does NOT strip the allowed class from <p>" do
    input =
      ~S(<section><p class="red">hello <script>code!</script></p></section>)

    expected = ~S(<p class="red">hello code!</p>)
    assert expected == Custom2.sanitize(input)
  end
end
