defmodule HtmlSanitizeExScrubberStripTagsTest do
  use ExUnit.Case

  defp strip_tags(text) do
    HtmlSanitizeEx.strip_tags(text)
  end

  test "strips everything except the allowed tags (for multiple tags)" do
    input = "<section><header><script>code!</script></header><p>hello <script>code!</script></p></section>"
    expected = "code!hello code!"
    assert expected == strip_tags(input)
  end

  test "strips everything" do
    input = "<h1>hello<h1>"
    expected = "hello"
    assert expected == strip_tags(input)
  end

  test "strips invalid html" do
    input = "<<<bad html"
    expected = "&lt;&lt;"
    assert expected == strip_tags(input)
  end

  test "strips tags with quote" do
    input = "<\" <img src=\"trollface.gif\" onload=\"alert(1)\"> hi"
    assert "&lt;\"  hi" == strip_tags(input)
  end

  test "strips nested tags" do
    input = "Wei<<a>a onclick='alert(document.cookie);'</a>/>rdos"
    expected = "Wei&lt;a onclick='alert(document.cookie);'/&gt;rdos"
    assert expected == strip_tags(input)
  end


  test "strips tags in multi line strings" do
    input = "<title>This is <b>a <a href=\"\" target=\"_blank\">test</a></b>.</title>\n\n<!-- it has a comment -->\n\n<p>It no <b>longer <strong>contains <em>any <strike>HTML</strike></em>.</strong></b></p>\n"
    expected = "This is a test.It no longer contains any HTML."
    assert expected == strip_tags(input)
  end

  test "strips comments" do
    assert "This is &lt;-- not\n a comment here." == strip_tags("This is <-- not\n a comment here.")
  end

  test "strips blank string" do
    assert "" == strip_tags("")
    assert "" == strip_tags("  ")
    assert "" == strip_tags(nil)
  end

  test "strips nothing from plain text" do
    input = "Dont touch me"
    expected = "Dont touch me"
    assert expected == strip_tags(input)
  end

  test "strips tags with many open quotes" do
    assert "&lt;&lt;" == strip_tags("<<<bad html>")
  end

  test "strips nothing from a sentence" do
    input = "This is a test."
    expected = "This is a test."
    assert expected == strip_tags(input)
  end

  test "strips tags with comment" do
    input = "This has a <!-- comment --> here."
    expected = "This has a  here."
    assert expected == strip_tags(input)
  end

  test "strip_tags escapes special characters" do
    assert "&amp;", strip_tags("&")
  end

  # link sanitizer

  test "test_strip_links_with_tags_in_tags" do
    input = "<<a>a href='hello'>all <b>day</b> long<</A>/a>"
    expected = "&lt;a href='hello'&gt;all day long&lt;/a&gt;"
    assert expected == strip_tags(input)
  end

  test "test_strip_links_with_unclosed_tags" do
    assert "" == strip_tags("<a<a")
  end

  test "test_strip_links_with_plaintext" do
    assert "Dont touch me" == strip_tags("Dont touch me")
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
    expected = "text here"
    Enum.each(@a_href_hacks, fn(x) -> assert expected == strip_tags(x) end)
  end

  test "test_strip links with links" do
    input = "<a href='http://www.rubyonrails.com/'><a href='http://www.rubyonrails.com/' onlclick='steal()'>0wn3d</a></a>"
    assert "0wn3d" == strip_tags(input)
  end

  test "test_strip_links_with_a_tag_in_href" do
    assert "FrrFox" == strip_tags("<href onlclick='steal()'>FrrFox</a></href>")
  end

  test "normal scrubbing does only allow certain tags and attributes" do
    input = "<plaintext><span data-foo=\"bar\">foo</span></plaintext>"
    expected = "foo"
    assert expected == strip_tags(input)
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
    expected = ""
    Enum.each(@image_src_hacks, fn(x) -> assert expected == strip_tags(x) end)
  end

  test "strips script tag" do
    input = "<SCRIPT\nSRC=http://ha.ckers.org/xss.js></SCRIPT>"
    expected = ""
    assert expected == strip_tags(input)
  end

  test "should_sanitize_tag_broken_up_by_null" do
    assert "alert(\"XSS\")" == strip_tags("<SCR\0IPT>alert(\"XSS\")</SCR\0IPT>")
  end

  test "should_sanitize_invalid_script_tag" do
    input = "<SCRIPT/XSS SRC=\"http://ha.ckers.org/xss.js\"></SCRIPT>"
    assert "" == strip_tags(input)
  end

  test "should_sanitize_script_tag_with_multiple_open_brackets" do
    assert "&lt;alert(\"XSS\");//&lt;" == strip_tags "<<SCRIPT>alert(\"XSS\");//<</SCRIPT>"
    assert "" == strip_tags "<iframe src=http://ha.ckers.org/scriptlet.html\n<a"
  end

  test "should_sanitize_unclosed_script" do
    input = "<SCRIPT SRC=http://ha.ckers.org/xss.js?<B>"
    assert "" == strip_tags(input)
  end

  test "sanitize half open scripts" do
    input = "<IMG SRC=\"javascript:alert('XSS')\""
    assert "" == strip_tags(input)
  end

  test "should_not_fall_for_ridiculous_hack" do
    img_hack = """
    <IMG\nSRC\n=\n"\nj\na\nv\na\ns\nc\nr\ni\np\nt\n:\na\nl\ne\nr\nt\n(\n'\nX\nS\nS\n'\n)\n"\n>)
    """
    assert ")\n" == strip_tags(img_hack)
  end

  test "should_sanitize_within attributes" do
    input = "<span title=\"&#39;&gt;&lt;script&gt;alert()&lt;/script&gt;\">blah</span>"
    assert "blah" == strip_tags(input)
  end

  test "should_sanitize_invalid_tag_names" do
    assert "a b cd e f" == strip_tags(~s(a b c<script/XSS src="http://ha.ckers.org/xss.js"></script>d e f))
  end

  test "should_sanitize_non_alpha_and_non_digit_characters_in_tags" do
    assert "foo" == strip_tags("<a onclick!#$%&()*~+-_.,:;?@[/|\\]^`=alert(\"XSS\")>foo</a>")
  end

  @tag cdata: true
  test "should_sanitize_cdata_section" do
    assert "section]]&gt;" == strip_tags("<![CDATA[<span>section</span>]]>")
  end

  @tag cdata: true
  test "should_sanitize_cdata_section like any other" do
    assert "section]]&gt;" == strip_tags("<![CDATA[<script>section</script>]]>")
  end

  @tag cdata: true
  test "should_sanitize_unterminated_cdata_section" do
    assert "neverending..." == strip_tags("<![CDATA[<span>neverending...")
  end

  @tag cdata: true
  test "strips CDATA" do
    input = "This has a <![CDATA[<section>]]> here."
    expected = "This has a ]]&gt; here."
    assert expected == strip_tags(input)
  end

  test "should_sanitize_neverending_attribute" do
    assert "" == strip_tags("<span class=\"\\")
  end
end
