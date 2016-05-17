defmodule HtmlSanitizeEx.Scrubber do
  def scrub("", _) do
    ""
  end

  def scrub(nil, _) do
    ""
  end

  def scrub(html, scrubber_module) do
    html
    |> before_scrub
    |> scrubber_module.before_scrub
    |> HtmlSanitizeEx.Parser.parse
    |> HtmlSanitizeEx.Traverser.traverse(scrubber_module)
    |> HtmlSanitizeEx.Parser.to_html
  end

  defp before_scrub(html) do
    html
    |> String.replace(~r/(>)(\ +)(<)/, "\\1&#32;\\3")
  end
end
