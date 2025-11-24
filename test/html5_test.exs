defmodule HtmlSanitizeExScrubberHTML5Test do
  use ExUnit.Case, async: true

  defp full_html_sanitize(text) do
    HtmlSanitizeEx.html5(text)
  end

  test "strips nothing" do
    input = "This <b>is</b> <b>an</b> <i>example</i> of <u>space</u> eating."
    assert input == full_html_sanitize(input)
  end

  test "leaves the allowed tags alone" do
    input = ~S(<h1 class="heading" style="font-weight: bold">hello world!</h1>)
    assert input == full_html_sanitize(input)
  end

  test "leaves the allowed tags alone 2" do
    input = "<a href=\"http://github.com\" class=\"ext\">hello world!</a>"
    assert input == full_html_sanitize(input)
  end

  test "leaves the allowed tags alone 3" do
    input =
      ~S(<h1 class="heading" data-confirm="Some confirmation text" style="font-weight: bold">hello world!</h1>)

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
    input =
      "<style> \@import url(javascript:alert('Your cookie:'+document.cookie)); </style>"

    expected = "<style> @import url(:'+document.cookie)); </style>"
    assert expected == full_html_sanitize(input)
  end

  test "handles bad css in style attribute" do
    input =
      "<h1 style=\"color: red; background-image: url('javascript:alert');  border: 1px solid brown;\">hello code!</h1>"

    expected =
      "<h1 style=\"color: red; :alert');  border: 1px solid brown;\">hello code!</h1>"

    assert expected == full_html_sanitize(input)
  end

  test "strips everything except the allowed tags (for multiple tags)" do
    input =
      "<section><header><script>code!</script></header><p>hello <script>code!</script></p></section>"

    expected = "<section><header>code!</header><p>hello code!</p></section>"
    assert expected == full_html_sanitize(input)
  end

  test "does not strip caption from tables" do
    input =
      "<table><caption>This is a table</caption><thead></thead><tbody></tbody></table>"

    expected =
      "<table><caption>This is a table</caption><thead></thead><tbody></tbody></table>"

    assert expected == full_html_sanitize(input)
  end

  test "does not strip divs" do
    input = ~s(<div class="a"><div class="b">Hello</div></div>)
    expected = ~s(<div class="a"><div class="b">Hello</div></div>)
    assert expected == full_html_sanitize(input)
  end

  test "does not strip the mailto URI scheme" do
    input = ~s(<a href="mailto:someone@yoursite.com">Email Us</a>)
    expected = ~s(<a href="mailto:someone@yoursite.com">Email Us</a>)
    assert expected == full_html_sanitize(input)
  end

  test "does encode script in textarea, but preserves white-space" do
    input = ~s(<textarea> <script></script></textarea>)
    expected = ~s(<textarea> &lt;script&gt;&lt;/script&gt;</textarea>)
    assert expected == full_html_sanitize(input)
  end

  test "does not contain replacement characters in result" do
    input = ~s[<script>alert()</script> <p>Hi</p>]
    expected = ~s[alert() <p>Hi</p>]
    assert expected == full_html_sanitize(input)
  end

  test "does not strip valid html5 attributes from <img>" do
    input =
      ~s[<img src="http://abcd.com" width="100" height="100" translate="(0,0)" />]

    assert input == full_html_sanitize(input)
  end

  test "does not strip valid html5 attributes srcset and sizes from <img>" do
    input =
      ~s[<img src="http://abcd.com" srcset="elva-fairy-480w.jpg 480w, elva-fairy-800w.jpg 800w" sizes="(max-width: 600px) 480px, 800px" />]

    assert input == full_html_sanitize(input)
  end

  test "does not strip any header tags" do
    input = """
    <h1>Header 1</h1>
    <h2>Header 2</h2>
    <h3>Header 3</h3>
    <h4>Header 4</h4>
    <h5>Header 5</h5>
    <h6>Header 6</h6>
    """

    assert input == full_html_sanitize(input)
  end

  test "does not strip valid attributes from svg and shapes" do
    icon =
      ~s(<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewbox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
          <path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5"></path>
        </svg>)

    assert icon == full_html_sanitize(icon)
  end

  test "strip unsafe colours for fill and stroke in svg" do
    evil_hero_icon =
      ~s|<svg xmlns="http://www.w3.org/2000/svg"  fill="url(javascript:alert(1))" stroke="url(javascript:alert(1))" viewbox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
          <path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5"></path>
        </svg>|

    good_hero_icon =
      ~s|<svg xmlns="http://www.w3.org/2000/svg" viewbox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
          <path stroke-linecap="round" stroke-linejoin="round" d="m4.5 12.75 6 6 9-13.5"></path>
        </svg>|

    assert good_hero_icon == full_html_sanitize(evil_hero_icon)
  end

  test "strip unsafe colours for fill and stroke in rect, circle, line, polyline, polygon, path, g" do
    for tag <- ~w(rect circle line polyline polygon path g) do
      evil_hero_icon =
        ~s|<svg xmlns="http://www.w3.org/2000/svg"  viewbox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
          <#{tag} fill="url(javascript:alert(1))" stroke="url(javascript:alert(1))" stroke-linecap="round" stroke-linejoin="round"></#{tag}>
        </svg>|

      good_hero_icon =
        ~s|<svg xmlns="http://www.w3.org/2000/svg" viewbox="0 0 24 24" stroke-width="1.5" stroke="currentColor" class="size-6">
          <#{tag} stroke-linecap="round" stroke-linejoin="round"></#{tag}>
        </svg>|

      assert good_hero_icon == full_html_sanitize(evil_hero_icon)
    end
  end

  test "make sure a very long URI is truncated before capturing URI scheme" do
    input =
      "<img src='#{File.read!(Path.join(__DIR__, "html5_test_data_uri"))}'>"

    assert "<img />" == full_html_sanitize(input)
  end
end
