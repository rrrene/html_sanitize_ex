defmodule StripEverythingButB do
  def scrub({"b", attributes, children}), do: {"b", attributes, children}

  def scrub({_tag, _attributes, children}) do
    children
  end

  def scrub(text) do
    text
  end
end

defmodule HtmlSanitizeExTraverserTest do
  use ExUnit.Case

  def parse_to_tree(html) do
    html
    |> HtmlSanitizeEx.Parser.parse
    |> HtmlSanitizeEx.Traverser.traverse(StripEverythingButB)
  end

  test "should return expected tree" do
    input = "hello! <section><b><script>code!</script></b><p>hello <script>code!</script></p></section>"
    expected = ["hello! ", {"b", [], ["code!"]}, "hello ", "code!"]
    assert expected == parse_to_tree(input)
  end

  test "should return expected tree 2" do
    input = "<title>This is <b>the <a href=\"http://me@example.com\" target=\"_blank\">test</a></b>.</title><p>It no <b>longer <strong>contains <em>any <strike>HTML</strike></em>.</strong></b></p>"
    expected = ["This is ", {"b", [], ["the ", "test"]}, ".", "It no ", {"b", [], ["longer ", "contains ", "any ", "HTML", "."]}]
    assert expected == parse_to_tree(input)
  end

  test "should return expected tree 3" do
    input = "This has a <!-- comment --> here."
    expected = ["This has a ", {:comment, " comment "}, " here."]
    assert expected == parse_to_tree(input)
  end

  test "should return expected tree 4" do
    input = "This has a <!-- comment here."
    expected = ["This has a ", {:comment, " comment here.</html_sanitize_ex>"}]
    assert expected == parse_to_tree(input)
  end

  test "should return expected tree 5" do
    input = "<<<bad html"
    expected = ["<<"]
    assert expected == parse_to_tree(input)
  end

  test "should return expected tree 6" do
    input = "<\" <img src=\"trollface.gif\" onload=\"alert(1)\"> hi"
    expected = ["<\" ", " hi"]
    assert expected == parse_to_tree(input)
  end

  test "should return expected tree 7" do
    input = "This has a <![CDATA[<section>]]> here."
    expected = "This has a <section> here."
    assert expected == parse_to_tree(input)
  end
end
