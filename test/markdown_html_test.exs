defmodule HtmlSanitizeExScrubberMarkdownHTMLTest do
  use ExUnit.Case

  defp sanitize(text) do
    text |> HtmlSanitizeEx.Scrubber.scrub(HtmlSanitizeEx.Scrubber.MarkdownHTML)
  end

  test "strips nothing" do
    input = "This <b>is</b> <b>an</b> <i>example</i> of <u>space</u> eating."
    expected = "This <b>is</b> <b>an</b> <i>example</i> of <u>space</u> eating."
    assert expected == sanitize(input)
  end

  test "does NOT strip language class from code tag" do
    input = "<code class=\"ruby\">Something.new</code>"
    assert input == sanitize(input)
  end

  test "strips everything except the allowed tags" do
    input = "<h1>hello <script>code!</script></h1>"
    expected = "<h1>hello code!</h1>"
    assert expected == sanitize(input)
  end

  test "allows target=_blank inside <a>" do
    input = ~S(<a href="test.html" target="_blank" name="testpoint">hello world</a>)
    expected = ~S(<a href="test.html" target="_blank" name="testpoint">hello world</a>)
    assert expected == sanitize(input)
  end

  test "strips everything except the allowed tags (for multiple tags)" do
    input = "<section><header><script>code!</script></header><p>hello <script>code!</script></p></section>"
    expected = "code!<p>hello code!</p>"
    assert expected == sanitize(input)
  end

  test "strips everything for faulty allowed_tags: key" do
    input = "<h1>hello<h1>"
    expected = "hello"
    assert expected != sanitize(input)
  end

  test "strips invalid html" do
    input = "<<<bad html"
    expected = "&lt;&lt;"
    assert expected == sanitize(input)
  end

  test "strips tags with quote" do
    input = "<\" <img src=\"trollface.gif\" onload=\"alert(1)\"> hi"
    assert "&lt;\" <img src=\"trollface.gif\" /> hi" == sanitize(input)
  end

  test "strips nested tags" do
    input = "Wei<<a>a onclick='alert(document.cookie);'</a>/>rdos"
    expected = "Wei&lt;<a>a onclick='alert(document.cookie);'</a>/&gt;rdos"
    assert expected == sanitize(input)
  end

  test "strips certain tags in multi line strings" do
    input = "<title>This is <b>a <a href=\"\" target=\"_top\">test</a></b>.</title>\n\n<!-- it has a comment -->\n\n<p>It no <b>longer <strong>contains <em>any <strike>HTML</strike></em>.</strong></b></p>\n"
    expected = "This is <b>a <a href=\"\">test</a></b>.<p>It no <b>longer <strong>contains <em>any HTML</em>.</strong></b></p>"
    assert expected == sanitize(input)
  end

  test "strips blank string" do
    assert "" == sanitize("")
    assert "" == sanitize("  ")
    assert "" == sanitize(nil)
  end

  test "strips nothing from plain text" do
    input = "Dont touch me"
    expected = "Dont touch me"
    assert expected == sanitize(input)
  end

  test "strips nothing from a sentence" do
    input = "This is a test."
    expected = "This is a test."
    assert expected == sanitize(input)
  end

  test "strips tags with comment" do
    input = "This has a <!-- comment --> here."
    expected = "This has a  here."
    assert expected == sanitize(input)
  end

  test "strip_tags escapes special characters" do
    assert "&amp;", sanitize("&")
  end

  # link sanitizer

  test "test_strip_links_with_tags_in_tags" do
    input = "<<a>a href='hello'>all <b>day</b> long<</A>/a>"
    expected = "&lt;<a>a href='hello'&gt;all <b>day</b> long&lt;</a>/a&gt;"
    assert expected == sanitize(input)
  end

  test "test_strip_links_with_unclosed_tags" do
    assert "" == sanitize("<a<a")
  end

  test "test_strip_links_with_plaintext" do
    assert "Dont touch me" == sanitize("Dont touch me")
  end

  @tag href_scrubbing: true
  test "test_strip_links_with_line_feed_and_uppercase_tag" do
    input = "<a href='almost'>on my mind</a> <A href='almost'>all day long</A>"
    assert "<a href=\"almost\">on my mind</a> <a href=\"almost\">all day long</a>" == sanitize(input)
  end

  @tag href_scrubbing: true
  test "test_strip_links_leaves_nonlink_tags" do
    assert "<a href=\"almost\">My mind</a><a href=\"almost\">all <b>day</b> long</a>" == sanitize("<a href='almost'>My mind</a>\n<A href='almost'>all <b>day</b> long</A>")
  end

  @tag href_scrubbing: true
  test "strips tags with sanitize/1" do
    input = "<p>This <u>is</u> a <a href='test.html'><strong>test</strong></a>.</p>"
    assert "<p>This <u>is</u> a <a href=\"test.html\"><strong>test</strong></a>.</p>" == sanitize(input)
  end

  @a_href_hacks [
    "<a href=\"javascript:alert('XSS');\">text here</a>",
    "<a href=javascript:alert('XSS')>text here</a>",
    "<a href=JaVaScRiPt:alert('XSS')>text here</a>",
    "<a href=javascript:alert(&quot;XSS&quot;)>text here</a>",
    "<a href=javascript:alert(String.fromCharCode(88,83,83))>text here</a>",
    "<a href=&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#97;&#108;&#101;&#114;&#116;&#40;&#39;&#88;&#83;&#83;&#39;&#41;>text here</a>",
    "<a href=&#0000106&#0000097&#0000118&#0000097&#0000115&#0000099&#0000114&#0000105&#0000112&#0000116&#0000058&#0000097&#0000108&#0000101&#0000114&#0000116&#0000040&#0000039&#0000088&#0000083&#0000083&#0000039&#0000041>text here</a>",
    "<a href=&#x6A&#x61&#x76&#x61&#x73&#x63&#x72&#x69&#x70&#x74&#x3A&#x61&#x6C&#x65&#x72&#x74&#x28&#x27&#x58&#x53&#x53&#x27&#x29>text here</a>",
    "<a href=\"jav\tascript:alert('XSS');\">text here</a>",
    "<a href=\"jav&#x09;ascript:alert('XSS');\">text here</a>",
    "<a href=\"jav&#x0A;ascript:alert('XSS');\">text here</a>",
    "<a href=\"jav&#x0D;ascript:alert('XSS');\">text here</a>",
    "<a href=\" &#14;  javascript:alert('XSS');\">text here</a>",
    "<a href=\"javascript&#x3a;alert('XSS');\">text here</a>",
    "<a href=`javascript:alert(\"RSnake says, 'XSS'\")`>text here</a>",
    "<a href=\"javascript&#x3a;alert('XSS');\">text here</a>",
    "<a href=\"javascript&#x003a;alert('XSS');\">text here</a>",
    "<a href=\"javascript&#x3A;alert('XSS');\">text here</a>",
    "<a href=\"javascript&#x003A;alert('XSS');\">text here</a>",
    "<a href=\"&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#97;&#108;&#101;&#114;&#116;&#40;&#39;&#88;&#83;&#83;&#39;&#41;\">text here</a>",
    "<a href=\"JAVASCRIPT:alert(\'foo\')\">text here</a>",
    "<a href=\"java<!-- -->script:alert(\'foo\')\">text here</a>",
    "<a href=\"awesome.html#this:stuff\">text here</a>",
    "<a href=\"java\0&#14;\t\r\n script:alert(\'foo\')\">text here</a>",
    "<a href=\"java&#0000001script:alert(\'foo\')\">text here</a>",
    "<a href=\"java&#0000000script:alert(\'foo\')\">text here</a>"
  ]

  @tag href_scrubbing: true
  test "strips malicious protocol hacks from a href attribute" do
    expected = "<a>text here</a>"
    Enum.each(@a_href_hacks, fn(x) -> assert expected == sanitize(x) end)
  end

  @tag href_scrubbing: true
  test "does not strip x03a legitimate" do
    assert "<a href=\"http://legit\"></a>" == sanitize("<a href=\"http&#x3a;//legit\">")
    assert "<a href=\"http://legit\"></a>" == sanitize("<a href=\"http&#x3A;//legit\">")
  end

  test "test_strip links with links" do
    input = "<a href='http://www.elixirstatus.com/'><a href='http://www.elixirstatus.com/' onlclick='steal()'>0wn3d</a></a>"
    assert "<a href=\"http://www.elixirstatus.com/\"><a href=\"http://www.elixirstatus.com/\">0wn3d</a></a>" == sanitize(input)
  end

  test "test_strip_links_with_linkception" do
    assert "<a href=\"http://www.elixirstatus.com/\">Mag<a href=\"http://www.elixir-lang.org/\">ic</a></a>" == sanitize("<a href='http://www.elixirstatus.com/'>Mag<a href='http://www.elixir-lang.org/'>ic")
  end

  test "test_strip_links_with_a_tag_in_href" do
    assert "FrrFox" == sanitize("<href onlclick='steal()'>FrrFox</a></href>")
  end

  test "normal scrubbing does only allow certain tags and attributes" do
    input = "<plaintext><span data-foo=\"bar\">foo</span></plaintext>"
    expected = "<span>foo</span>"
    assert expected == sanitize(input)
  end

  test "strips not allowed attributes" do
    input = "start <a title=\"1\" onclick=\"foo\">foo <bad>bar</bad> baz</a> end"
    expected = "start <a title=\"1\">foo bar baz</a> end"
    assert expected == sanitize(input)
  end

  test "sanitize_script" do
    assert "a b cblah blah blahd e f" == sanitize("a b c<script language=\"Javascript\">blah blah blah</script>d e f")
  end

  @tag href_scrubbing: true
  test "sanitize_js_handlers" do
    input = ~s(onthis="do that" <a href="#" onclick="hello" name="foo" onbogus="remove me">hello</a>)
    assert "onthis=\"do that\" <a href=\"#\" name=\"foo\">hello</a>" == sanitize(input)
  end

  test "sanitize_javascript_href" do
    raw = ~s(href="javascript:bang" <a href="javascript:bang" name="hello">foo</a>, <span href="javascript:bang">bar</span>)
    assert ~s(href="javascript:bang" <a name="hello">foo</a>, <span>bar</span>) == sanitize(raw)
  end

  test "sanitize_image_src" do
    raw = ~s(src="javascript:bang" <img src="javascript:bang" width="5">foo</img>, <span src="javascript:bang">bar</span>)
    assert "src=\"javascript:bang\" <img width=\"5\" />, <span>bar</span>" == sanitize(raw)
  end

  @tag href_scrubbing: true
  test "should only allow http/https protocols" do
    assert "<a href=\"foo\">baz</a>" == sanitize(~s(<a href="foo" onclick="bar"><script>baz</script></a>))
    assert "<a href=\"http://example.com\">baz</a>" == sanitize(~s(<a href="http://example.com" onclick="bar"><script>baz</script></a>))
    assert "<a href=\"https://example.com\">baz</a>" == sanitize(~s(<a href="https://example.com" onclick="bar"><script>baz</script></a>))
  end

  #test "video_poster_sanitization" do
  #  assert ~s(<video src="videofile.ogg" autoplay  poster="posterimage.jpg"></video>) == ~s(<video src="videofile.ogg" poster="posterimage.jpg"></video>)
  #  assert ~s(<video src="videofile.ogg"></video>) == sanitize("<video src=\"videofile.ogg\" poster=javascript:alert(1)></video>")
  #end

  test "strips not allowed tags " do
    input = "<form><u></u></form>"
    expected = "<u></u>"
    assert expected == sanitize(input)
  end

  test "strips not allowed attributes " do
    input = "<a foo=\"hello\" bar=\"world\"></a>"
    expected = "<a></a>"
    assert expected == sanitize(input)
  end

  @image_src_hacks [
    "<IMG SRC=\"javascript:alert('XSS');\">",
    "<IMG SRC=javascript:alert('XSS')>",
    "<IMG SRC=JaVaScRiPt:alert('XSS')>",
    "<IMG SRC=javascript:alert(&quot;XSS&quot;)>",
    "<IMG SRC=javascript:alert(String.fromCharCode(88,83,83))>",
    "<IMG SRC=&#106;&#97;&#118;&#97;&#115;&#99;&#114;&#105;&#112;&#116;&#58;&#97;&#108;&#101;&#114;&#116;&#40;&#39;&#88;&#83;&#83;&#39;&#41;>",
    "<IMG SRC=&#0000106&#0000097&#0000118&#0000097&#0000115&#0000099&#0000114&#0000105&#0000112&#0000116&#0000058&#0000097&#0000108&#0000101&#0000114&#0000116&#0000040&#0000039&#0000088&#0000083&#0000083&#0000039&#0000041>",
    "<IMG SRC=&#x6A&#x61&#x76&#x61&#x73&#x63&#x72&#x69&#x70&#x74&#x3A&#x61&#x6C&#x65&#x72&#x74&#x28&#x27&#x58&#x53&#x53&#x27&#x29>",
    "<IMG SRC=\"jav\tascript:alert('XSS');\">",
    "<IMG SRC=\"jav&#x09;ascript:alert('XSS');\">",
    "<IMG SRC=\"jav&#x0A;ascript:alert('XSS');\">",
    "<IMG SRC=\"jav&#x0D;ascript:alert('XSS');\">",
    "<IMG SRC=\" &#14;  javascript:alert('XSS');\">",
    "<IMG SRC=\"javascript&#x3a;alert('XSS');\">",
    "<IMG SRC=`javascript:alert(\"RSnake says, 'XSS'\")`>"]

  test "strips malicious protocol hacks from img src attribute" do
    expected = "<img />"
    Enum.each(@image_src_hacks, fn(x) -> assert expected == sanitize(x) end)
  end

  test "strips script tag" do
    input = "<SCRIPT\nSRC=http://ha.ckers.org/xss.js></SCRIPT>"
    expected = ""
    assert expected == sanitize(input)
  end

  test "strips xss image hack with uppercase tags" do
    input = "<IMG \"\"\"><SCRIPT>alert(\"XSS\")</SCRIPT>\">"
    expected = "<img />alert(\"XSS\")\"&gt;"
    assert expected == sanitize(input)
  end


  test "should_sanitize_tag_broken_up_by_null" do
    assert "alert(\"XSS\")" == sanitize("<SCR\0IPT>alert(\"XSS\")</SCR\0IPT>")
  end

  test "should_sanitize_invalid_script_tag" do
    input = "<SCRIPT/XSS SRC=\"http://ha.ckers.org/xss.js\"></SCRIPT>"
    assert "" == sanitize(input)
  end

  test "should_sanitize_unclosed_script" do
    input = "<SCRIPT SRC=http://ha.ckers.org/xss.js?<B>"
    assert "" == sanitize(input)
  end

  test "sanitize half open scripts" do
    input = "<IMG SRC=\"javascript:alert('XSS')\""
    assert "<img />" == sanitize(input)
  end

  test "should_not_fall_for_ridiculous_hack" do
    img_hack = """
    <IMG\nSRC\n=\n"\nj\na\nv\na\ns\nc\nr\ni\np\nt\n:\na\nl\ne\nr\nt\n(\n'\nX\nS\nS\n'\n)\n"\n>)
    """
    assert "<img />)\n" == sanitize(img_hack)
  end

  test "should_sanitize_within attributes" do
    input = "<span title=\"&#39;&gt;&lt;script&gt;alert()&lt;/script&gt;\">blah</span>"
    assert "<span>blah</span>" == sanitize(input)
  end

  test "should_sanitize_invalid_tag_names" do
  end

  test "should_sanitize_non_alpha_and_non_digit_characters_in_tags" do
    assert "<a></a>foo" == sanitize("<a onclick!#$%&()*~+-_.,:;?@[/|\\]^`=alert(\"XSS\")>foo</a>")
  end

  test "should_sanitize_invalid_tag_names_in_single_tags" do
    assert "<img />" == sanitize("<img/src=\"http://ha.ckers.org/xss.js\"/>")
  end

  test "should_sanitize_img_dynsrc_lowsrc" do
    assert "<img />" == sanitize("<img lowsrc=\"javascript:alert('XSS')\" />")  end

  test "should_sanitize_img_vbscript" do
    assert "<img />" == sanitize("<img src='vbscript:msgbox(\"XSS\")' />")
  end

  @tag cdata: true
  test "should_sanitize_cdata_section" do
    assert "<span>section</span>]]&gt;" == sanitize("<![CDATA[<span>section</span>]]>")
  end

  @tag cdata: true
  test "should_sanitize_cdata_section like any other" do
    assert "section]]&gt;" == sanitize("<![CDATA[<script>section</script>]]>")
  end

  @tag cdata: true
  test "should_sanitize_unterminated_cdata_section" do
    assert "<span>neverending...</span>" == sanitize("<![CDATA[<span>neverending...")
  end

  @tag cdata: true
  test "strips CDATA" do
    input = "This has a <![CDATA[<section>]]> here."
    expected = "This has a ]]&gt; here."
    assert expected == sanitize(input)
  end

  test "should_not_mangle_urls_with_ampersand" do
    input = "<a href=\"http://www.domain.com?var1=1&amp;var2=2\">my link</a>"
    assert input == sanitize(input)
  end

  test "should_sanitize_neverending_attribute" do
    assert "<span></span>" == sanitize("<span class=\"\\")
  end

  #test "this affects only NS4, but we're on a roll, right?" do
  #  input = "<div size=\"&{alert('XSS')}\">foo</div>"
  #  expected = "<div>foo</div>"
  #  assert expected == sanitize(input)
  #end
end
