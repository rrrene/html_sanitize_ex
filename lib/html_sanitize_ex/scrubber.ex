defmodule HtmlSanitizeEx.Scrubber do
  @callback before_scrub(html :: String.t()) :: String.t()

  @type node_with_children :: {tag :: String.t(), attributes :: Keyword.t(), children :: list()}
  @callback scrub(node_with_children()) :: node_with_children()

  @callback scrub({token :: atom, children :: list()}) :: tuple

  @callback scrub(text :: String.t()) :: String.t()

  @callback scrub_attributes(tag :: String.t(), attributes :: Keyword.t()) :: Keyword.t()

  @callback scrub_attribute(tag :: String.t(), attribute :: String.t()) :: tuple

  def scrub(html, scrubber_module)

  def scrub("", _) do
    ""
  end

  def scrub(nil, _) do
    ""
  end

  def scrub("" <> html, scrubber_module) do
    html
    |> scrubber_module.before_scrub()
    |> HtmlSanitizeEx.Parser.parse()
    |> HtmlSanitizeEx.Traverser.traverse(scrubber_module)
    |> HtmlSanitizeEx.Parser.to_html()
  end
end
