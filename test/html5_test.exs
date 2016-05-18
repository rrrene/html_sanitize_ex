defmodule HtmlSanitizeExScrubberHTML5Test do
  use ExUnit.Case

  defp full_html_sanitize(text) do
    HtmlSanitizeEx.html5(text)
  end

  test "strips nothing" do
    input = "This <b>is</b> <b>an</b> <i>example</i> of <u>space</u> eating."
    assert input == full_html_sanitize(input)
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

  test "handles css" do
    input = "<style> div.foo { width: 500px; height: 200px; } </style>"
    assert input == full_html_sanitize(input)
  end

  test "handles bad css" do
    input = "<style> \@import url(javascript:alert('Your cookie:'+document.cookie)); </style>"
    expected = "<style> @import url(:'+document.cookie)); </style>"
    assert expected == full_html_sanitize(input)
  end

  test "handles bad css in style attribute" do
    input = "<h1 style=\"color: red; background-image: url('javascript:alert');  border: 1px solid brown;\">hello code!</h1>"
    expected = "<h1 style=\"color: red; :alert');  border: 1px solid brown;\">hello code!</h1>"
    assert expected == full_html_sanitize(input)
  end

  test "strips everything except the allowed tags (for multiple tags)" do
    input = "<section><header><script>code!</script></header><p>hello <script>code!</script></p></section>"
    expected = "<section><header>code!</header><p>hello code!</p></section>"
    assert expected == full_html_sanitize(input)
  end

  test "handles svg" do
    input = "<svg class=\"svg\"><use xlink:href=\"svguse\"></use></svg>"
    assert input == full_html_sanitize(input)
  end

  test "handles bad css" do
    input = "<svg onload=\"badsvg\"><use onload=\"badsvguse\"></use></svg>"
    expected = "<svg><use></use></svg>"
    assert expected == full_html_sanitize(input)
  end
end
