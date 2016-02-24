defmodule HtmlSanitizeEx.Scrubber.NoScrub do
  @moduledoc """
  Scrubs neither tags, nor their attributes.

  This meant for testing purposes and as a template for your own scrubber.
  """

  @doc """
  Can be used to preprocess the given +html+ String before it is scrubbed.
  """
  def before_scrub(html) do
    html
  end

  @doc """
  Scrubs a single tag given its attributes and children.

  Calls `scrub_attribute/2` to scrub individual attributes.
  """
  def scrub({tag, attributes, children}) do
    {tag, scrub_attributes(tag, attributes), children}
  end

  @doc """
  Scrubs tokens like comments and doctypes.
  """
  def scrub({_token, children}), do: children

  @doc """
  Scrubs a text node.
  """
  def scrub(text) do
    text
  end

  @doc false
  def scrub_attributes(tag, attributes) do
    Enum.map(attributes, fn(attr) -> scrub_attribute(tag, attr) end)
    |> Enum.reject(&(is_nil(&1)))
  end

  @doc """
  Scrubs a single attribute for a given tag.

  You can utilize scrub_attribute to write custom matchers so you can sanitize
  specific attributes of specific tags:

  As an example, if you only want to allow href attribute with the "http" and
  "https" protocols, you could implement it like this:

      def scrub_attribute("a", {"href", "http" <> target}) do
        {"href", "http" <> target}
      end

      def scrub_attribute("a", {"href", _}) do
        nil
      end
  """
  def scrub_attribute(_tag, attribute) do
    attribute
  end
end
