defmodule HtmlSanitizeExScrubberStripTagsTest do
  use ExUnit.Case, async: true

  defp strip_tags(text) do
    HtmlSanitizeEx.strip_tags(text)
  end

  test "strips nothing from a sentence" do
    input = "This is a test."

    assert input == strip_tags(input)
  end

  test "strips everything" do
    input = "<h1>hello<h1>"
    expected = "hello"
    assert expected == strip_tags(input)
  end

  test "strips everything except the allowed tags (for multiple tags)" do
    input =
      "<section><header><script>code!</script></header><p>hello <script>code!</script></p></section>"

    expected = "code!hello code!"
    assert expected == strip_tags(input)
  end

  test "strips invalid html" do
    input = "<<<bad html"
    expected = "&lt;&lt;"
    assert expected == strip_tags(input)
  end

  test "strips tags in multi line strings" do
    input =
      "<title>This is <b>a <a href=\"\" target=\"_blank\">test</a></b>.</title>\n\n<!-- it has a comment -->\n\n<p>It no <b>longer <strong>contains <em>any <strike>HTML</strike></em>.</strong></b></p>\n"

    expected = "This is a test.\n\n\n\nIt no longer contains any HTML.\n"
    assert expected == strip_tags(input)
  end

  test "strips comments" do
    assert "This is &lt;-- not\n a comment here." ==
             strip_tags("This is <-- not\n a comment here.")
  end

  test "strips blank string" do
    assert "" == strip_tags("")
    assert "" == strip_tags("  ")
    assert "" == strip_tags(nil)
  end

  test "strips tags with many open quotes" do
    assert "&lt;&lt;" == strip_tags("<<<bad html>")
  end

  test "strips tags with comment" do
    input = "This has a <!-- comment --> here."
    expected = "This has a  here."
    assert expected == strip_tags(input)
  end

  test "strip_tags escapes special characters" do
    assert "&amp;", strip_tags("&")
  end

  test "normal scrubbing does only allow certain tags and attributes" do
    input = "<plaintext><span data-foo=\"bar\">foo</span></plaintext>"
    expected = "foo"
    assert expected == strip_tags(input)
  end

  test "should sanitize neverending attribute" do
    assert "" == strip_tags("<span class=\"\\")
  end

  test "should not destroy white-space" do
    assert "some\r\ntext" == strip_tags("some\r\ntext")
  end

  test "should not destroy white-space /2" do
    assert "sometext with break between tags\r\nwill remove break" ==
             strip_tags("some<b>text with break between tags</b>\r\n<i>will remove break</i>")
  end

  test "should not destroy white-space /3" do
    assert "some text\r\nbreak only from one side" ==
             strip_tags("some text\r\n<b>break only from one side</b>")
  end

  describe "<a>" do
    # link sanitizer

    @tag href_scrubbing: true
    test "strips malicious protocol hacks from a href attribute" do
      {_, href_hacks} = Fixtures.a_href_hacks()
      expected = "text here"
      Enum.each(href_hacks, fn x -> assert expected == strip_tags(x) end)
    end

    test "test_strip_links_with_tags_in_tags" do
      input = "<<a>a href='hello'>all <b>day</b> long<</A>/a>"
      expected = "&lt;a href='hello'&gt;all day long&lt;/a&gt;"
      assert expected == strip_tags(input)
    end

    test "test_strip_links_with_unclosed_tags" do
      assert "" == strip_tags("<a<a")
    end

    test "test_strip links with links" do
      input =
        "<a href='http://www.rubyonrails.com/'><a href='http://www.rubyonrails.com/' onlclick='steal()'>0wn3d</a></a>"

      assert "0wn3d" == strip_tags(input)
    end

    test "test_strip_links_with_a_tag_in_href" do
      assert "FrrFox" == strip_tags("<href onlclick='steal()'>FrrFox</a></href>")
    end

    test "strips nested tags" do
      input = "Wei<<a>a onclick='alert(document.cookie);'</a>/>rdos"
      expected = "Wei&lt;a onclick='alert(document.cookie);'/&gt;rdos"
      assert expected == strip_tags(input)
    end

    test "should_sanitize_non_alpha_and_non_digit_characters_in_tags" do
      assert "foo" == strip_tags("<a onclick!#$%&()*~+-_.,:;?@[/|\\]^`=alert(\"XSS\")>foo</a>")
    end
  end

  describe "<img>" do
    # image sanitizer
    test "strips malicious protocol hacks from img src attribute" do
      {_, image_src_hacks} = Fixtures.image_src_hacks()
      expected = ""
      Enum.each(image_src_hacks, fn x -> assert expected == strip_tags(x) end)
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

    test "strips tags with quote" do
      input = "<\" <img src=\"trollface.gif\" onload=\"alert(1)\"> hi"
      assert "&lt;\"  hi" == strip_tags(input)
    end
  end

  describe "<script>" do
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
      assert "&lt;alert(\"XSS\");//&lt;" ==
               strip_tags("<<SCRIPT>alert(\"XSS\");//<</SCRIPT>")

      assert "" ==
               strip_tags("<iframe src=http://ha.ckers.org/scriptlet.html\n<a")
    end

    test "should_sanitize_unclosed_script" do
      input = "<SCRIPT SRC=http://ha.ckers.org/xss.js?<B>"
      assert "" == strip_tags(input)
    end

    test "should_sanitize_within attributes" do
      input = "<span title=\"&#39;&gt;&lt;script&gt;alert()&lt;/script&gt;\">blah</span>"

      assert "blah" == strip_tags(input)
    end

    test "should_sanitize_invalid_tag_names" do
      assert "a b cd e f" ==
               strip_tags(~s(a b c<script/XSS src="http://ha.ckers.org/xss.js"></script>d e f))
    end
  end

  describe "<![CDATA[" do
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
  end
end
