defmodule HtmlSanitizeEx.Scrubber.BasicHTML do
  def before_scrub(text) do
    HtmlSanitizeEx.Scrubber.StripTags.before_scrub(text)
  end

  require HtmlSanitizeEx.Scrubber.Meta
  alias HtmlSanitizeEx.Scrubber.Meta

  Meta.allow_tags_and_scrub_its_attributes ["h1", "h2", "h3", "h4", "h5",
                  "a", "b", "blockquote", "br", "code", "del", "em", "hr", "i",
                  "img", "li", "ol", "ul", "p", "pre", "span", "strong", "u",
                  "table", "tbody", "td", "th", "thead", "tr"]

  Meta.allow_tag_with_these_attributes "a", ["name", "title"]

  def scrub_attribute("a", {"href", "&" <> _}), do: nil

  def scrub_attribute("a", {"href", href}) do
    IO.inspect href
    if no_scheme?(href) || valid_scheme?(href) do
      {"href", href}
    end
  end

  Meta.allow_tag_with_these_attributes "img", ["width", "height", "title", "alt"]

  def scrub_attribute("img", {"src", "http://" <> src}) do
    if no_scheme?(src) || valid_scheme?(src) do
      {"src", src}
    end
  end

  defp no_scheme?(uri) do
    !String.match?(uri, ~r/\:/)
  end

  @valid_schemes ["http://", "https://"]

  defp valid_scheme?(uri) do
    String.starts_with?(uri, @valid_schemes)
  end

  # If we have covered the attribute until here, we just scrab it.
  def scrub_attribute(tag, attribute) do
    nil
  end

  # If we haven't covered the attribute until here, we just scrab it.
  def scrub({tag, attributes, children}) do
    children
  end

  def scrub({:comment, children}), do: ""
  def scrub({token, children}), do: children

  @doc """
    Scrubs a text node.
  """
  def scrub(text) do
    scrub_text(text)
  end

  @doc false
  def scrub_attributes(tag, attributes) do
    Enum.map(attributes, fn(attr) -> scrub_attribute(tag, attr) end)
      |> Enum.reject(&(is_nil(&1)))
  end

  def scrub_text(text) do
    text
  end
end
