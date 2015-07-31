defmodule HtmlSanitizeExScrubberHTML5Test do
  use ExUnit.Case

  defp full_html_sanitize(text) do
    HtmlSanitizeEx.html5(text)
  end

  test "leaves the allowed tags alone" do
    input = "<h1 class=\"heading\">hello world!</h1>"
    expected = "<h1 class=\"heading\">hello world!</h1>"
    assert expected == full_html_sanitize(input)
  end

  test "leaves the allowed tags alone 2" do
    input = "<a href=\"http://github.com\" class=\"ext\">hello world!</a>"
    assert input == full_html_sanitize(input)
  end

  test "strips everything except the allowed tags" do
    input = "<h1>hello <script>code!</script></h1>"
    expected = "<h1>hello code!</h1>"
    assert expected == full_html_sanitize(input)
  end

  test "strips everything except the allowed tags (for multiple tags)" do
    input = "<section><header><script>code!</script></header><p>hello <script>code!</script></p></section>"
    expected = "<section><header>code!</header><p>hello code!</p></section>"
    assert expected == full_html_sanitize(input)
  end
end
