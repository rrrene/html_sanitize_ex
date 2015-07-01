defmodule HtmlSanitizeExTest do
  use ExUnit.Case

  test "strips all the tags" do
    input = "hello! <section><header><script>code!</script></header><p>hello <script>code!</script></p></section>"
    assert "hello! code!hello code!" == HtmlSanitizeEx.strip_tags(input)
  end
end
