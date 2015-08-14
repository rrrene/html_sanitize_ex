defmodule HtmlSanitizeExScrubberCSSTest do
  use ExUnit.Case

  def scrub_css(text) do
    HtmlSanitizeEx.Scrubber.CSS.scrub(text)
  end

  @good_css [
      ".test { color: red; border: 1px solid brown; }",
      "div.foo { width: 500px; height: 200px; }",
      "GI b gkljfl kj { { { ********" # gibberish should work
    ]

  test "should return valid css" do
    Enum.each(@good_css, fn text ->
      assert text == scrub_css(text)
    end)
  end

  @good_css_background [
      "h1 { background: url(http://foobar.com/meh.jpg)}",
    ]

  test "should return valid css 2" do
  #  Enum.each(@good_css_background, fn text ->
  #    assert text == scrub_css(text)
  #  end)
  end

  @evil_css [
      "div.foo { width: 500px; behavior: url(http://foo.com); height: 200px; }",
      ".test { color: red; background-image: url('javascript:alert');  border: 1px solid brown; }",
      "div.foo { width: 500px; -moz-binding: foo; height: 200px; }",

      # no @import for you
      "\@import url(javascript:alert('Your cookie:'+document.cookie));",

      # no behavior either
      "behaviour:expression(function(element){alert(&#39;xss&#39;);}(this));'>",

      # case-sensitivity test
      "-Moz-binding: url(\"http://www.example.comtest.xml\");",

      # \\d gets parsed out on ffx and ie
      "background:url(&quot;javascri\\dpt:alert('injected js goes here')&quot;)",

      # http://rt.livejournal.org/Ticket/Display.html?id=436
      "-\4d oz-binding: url(\"http://localhost/test.xml#foo\");",

      # css comments are ignored sometimes
      "xss:expr/*XSS*/ession(alert('XSS'));",

      # html comments? fail
      "background:url(java<!-- -->script:alert('XSS'));",

      "a.foo { ba/* hack */r: x }",

      # weird comments
      "color: e/* * / */xpression(\"r\" + \"e\" + \"d\");",

      # weird comments to really test that regex
      "color: e/*/**/xpression(\"r\" + \"e\" + \"d\");",

      # we're not using a parser, but nonetheless ... if we were..
      """
      p {
      dummy: '//'; background:url(javascript:alert('XSS'));
      }
      """,

      """
      test{ width: expression(alert("sux 2 be u")); }
      a:link { color: red }
      """
      ]

  test "should NOT return invalid css" do
    Enum.each(@evil_css, fn text ->
      assert text != scrub_css(text)
    end)
  end

  @evil_css_background [
      # \uxxrl unicode
      "background:\\75rl('javascript:alert(\"\\75rl\")');",
      "background:&#x75;rl(javascript:alert('html &amp;#x75;'))",
      "b\\nackground: url(javascript:alert('line-broken background '))",
      "background:&#xff55;rl(javascript:alert('&amp;#xff55;rl(full-width u)'))",
      "background:&#117;rl(javascript:alert(&amp;#117;rl'))",
      "background:&#x75;rl(javascript:alert('&amp;#x75;rl'))",
      "background:\\75rl('javascript:alert(\"\\75rl\")')",

      # \uxxrl unicode
      "div { background:\\75rl('javascript:alert(\"\\75rl\")'); }",
      "div { background:&#x75;rl(javascript:alert('html &amp;#x75;')) }",
      "div { b\\nackground: url(javascript:alert('line-broken background ')) }",
      "div { background:&#xff55;rl(javascript:alert('&amp;#xff55;rl(full-width u)')) }",
      "div { background:&#117;rl(javascript:alert(&amp;#117;rl')) }",
      "div { background:&#x75;rl(javascript:alert('&amp;#x75;rl')) }",
      "div { background:\\75rl('javascript:alert(\"\\75rl\")') }",

      ]

  test "should NOT return invalid css 2" do
    Enum.each(@evil_css_background, fn text ->
      assert text != scrub_css(text)
    end)
  end

end
