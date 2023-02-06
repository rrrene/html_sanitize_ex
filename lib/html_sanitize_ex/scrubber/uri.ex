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

  def valid_schema?(uri, valid_schemes) do
    if uri =~ @protocol_separator_regex do
      case Regex.named_captures(
             @scheme_capture,
             String.slice(uri, 0..@max_scheme_length)
           ) do
        %{"scheme" => scheme, "other_schemes" => ""} ->
          scheme in valid_schemes

        %{"other_schemes" => scheme, "scheme" => ""} ->
          scheme in valid_schemes

        _ ->
          false
      end
    else
      true
    end
  end
end
