defmodule HtmlSanitizeEx.Scrubber.StripTags do
  @moduledoc """
  Strips all tags.
  """

  def before_scrub(text) do
    String.replace(text, "<![CDATA[", "")
  end

  def scrub({_, _, children}), do: children
  def scrub({:comment, children}), do: ""
  def scrub({_, children}), do: children
  def scrub(text), do: text
end
