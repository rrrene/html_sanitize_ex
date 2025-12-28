defmodule HtmlSanitizeEx.Scrubber.URI do
  @moduledoc false

  @protocol_separator ":|(&#0*58)|(&#x70)|(&#x0*3a)|(%|&#37;)3A"
  @protocol_separator_regex Regex.compile!(@protocol_separator, "mi")

  @http_like_scheme "(?<scheme>.+?)(#{@protocol_separator})//"
  @other_schemes "(?<other_schemes>.+)(#{@protocol_separator})"

  @scheme_capture Regex.compile!(
                    "(#{@http_like_scheme})|(#{@other_schemes})",
                    "mi"
                  )

  @max_scheme_length 20

  def scrub_attribute(tag, attr_name_and_uri, valid_schemes)

  def scrub_attribute(_tag, {_attr_name, "&" <> _value}, _valid_schemes) do
    nil
  end

  def scrub_attribute(_tag, {attr_name, uri}, valid_schemes) do
    if valid_schema?(uri, valid_schemes) do
      {attr_name, uri}
    end
  end

  def valid_schema?(uri, valid_schemes) do
    if uri =~ @protocol_separator_regex do
      schema(uri) in valid_schemes
    else
      true
    end
  end

  defp schema(uri) do
    uri_start = String.slice(uri, 0..@max_scheme_length)

    case Regex.named_captures(@scheme_capture, uri_start) do
      %{"scheme" => scheme, "other_schemes" => ""} -> scheme
      %{"other_schemes" => scheme, "scheme" => ""} -> scheme
      _ -> nil
    end
  end
end
