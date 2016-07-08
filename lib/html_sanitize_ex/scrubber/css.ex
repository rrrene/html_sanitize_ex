defmodule HtmlSanitizeEx.Scrubber.CSS do
  @moduledoc """
  Scrub CSS.
  """

  def scrub(nil), do: ""
  def scrub(text) do
    text = String.replace(text, ~r/(\/\*|\*\/|<!--|-->)/, " ")
    Regex.replace(~r/([-\w]+)\s*:\s*([^:;]*)/, text, fn _all, a, b ->
      case scrub_css(a, b) do
        {property, value} -> "#{property}: #{value}"
        nil -> ""
      end
    end)
  end

  defp scrub_css("azimuth", val), do: validate {"azimuth", scrub_val(val)}
  defp scrub_css("background-color", val), do: validate {"background-color", scrub_val(val)}
  defp scrub_css("border-bottom-color", val), do: validate {"border-bottom-color", scrub_val(val)}
  defp scrub_css("border-collapse", val), do: validate {"border-collapse", scrub_val(val)}
  defp scrub_css("border-color", val), do: validate {"border-color", scrub_val(val)}
  defp scrub_css("border-left-color", val), do: validate {"border-left-color", scrub_val(val)}
  defp scrub_css("border-right-color", val), do: validate {"border-right-color", scrub_val(val)}
  defp scrub_css("border-top-color", val), do: validate {"border-top-color", scrub_val(val)}
  defp scrub_css("clear", val), do: validate {"clear", scrub_val(val)}
  defp scrub_css("color", val), do: validate {"color", scrub_val(val)}
  defp scrub_css("cursor", val), do: validate {"cursor", scrub_val(val)}
  defp scrub_css("direction", val), do: validate {"direction", scrub_val(val)}
  defp scrub_css("display", val), do: validate {"display", scrub_val(val)}
  defp scrub_css("elevation", val), do: validate {"elevation", scrub_val(val)}
  defp scrub_css("float", val), do: validate {"float", scrub_val(val)}
  defp scrub_css("font", val), do: validate {"font", scrub_val(val)}
  defp scrub_css("font-family", val), do: validate {"font-family", scrub_val(val)}
  defp scrub_css("font-size", val), do: validate {"font-size", scrub_val(val)}
  defp scrub_css("font-style", val), do: validate {"font-style", scrub_val(val)}
  defp scrub_css("font-variant", val), do: validate {"font-variant", scrub_val(val)}
  defp scrub_css("font-weight", val), do: validate {"font-weight", scrub_val(val)}
  defp scrub_css("height", val), do: validate {"height", scrub_val(val)}
  defp scrub_css("letter-spacing", val), do: validate {"letter-spacing", scrub_val(val)}
  defp scrub_css("line-height", val), do: validate {"line-height", scrub_val(val)}
  defp scrub_css("overflow", val), do: validate {"overflow", scrub_val(val)}
  defp scrub_css("pause", val), do: validate {"pause", scrub_val(val)}
  defp scrub_css("pause-after", val), do: validate {"pause-after", scrub_val(val)}
  defp scrub_css("pause-before", val), do: validate {"pause-before", scrub_val(val)}
  defp scrub_css("pitch", val), do: validate {"pitch", scrub_val(val)}
  defp scrub_css("pitch-range", val), do: validate {"pitch-range", scrub_val(val)}
  defp scrub_css("richness", val), do: validate {"richness", scrub_val(val)}
  defp scrub_css("speak", val), do: validate {"speak", scrub_val(val)}
  defp scrub_css("speak-header", val), do: validate {"speak-header", scrub_val(val)}
  defp scrub_css("speak-numeral", val), do: validate {"speak-numeral", scrub_val(val)}
  defp scrub_css("speak-punctuation", val), do: validate {"speak-punctuation", scrub_val(val)}
  defp scrub_css("speech-rate", val), do: validate {"speech-rate", scrub_val(val)}
  defp scrub_css("stress", val), do: validate {"stress", scrub_val(val)}
  defp scrub_css("text-align", val), do: validate {"text-align", scrub_val(val)}
  defp scrub_css("text-decoration", val), do: validate {"text-decoration", scrub_val(val)}
  defp scrub_css("text-indent", val), do: validate {"text-indent", scrub_val(val)}
  defp scrub_css("unicode-bidi", val), do: validate {"unicode-bidi", scrub_val(val)}
  defp scrub_css("vertical-align", val), do: validate {"vertical-align", scrub_val(val)}
  defp scrub_css("voice-family", val), do: validate {"voice-family", scrub_val(val)}
  defp scrub_css("volume", val), do: validate {"volume", scrub_val(val)}
  defp scrub_css("white-space", val), do: validate {"white-space", scrub_val(val)}
  defp scrub_css("width", val), do: validate {"width", scrub_val(val)}

  defp scrub_css("background", val), do: validate {"background", scrub_val(val)}
  defp scrub_css("background-" <> prop, val), do: validate {"background-#{prop}", scrub_val(val)}
  defp scrub_css("border", val), do: validate {"border", scrub_val(val)}
  defp scrub_css("border-" <> prop, val), do: validate {"border-#{prop}", scrub_val(val)}
  defp scrub_css("margin", val), do: validate {"margin", scrub_val(val)}
  defp scrub_css("margin-" <> prop, val), do: validate {"margin-#{prop}", scrub_val(val)}
  defp scrub_css("padding", val), do: validate {"padding", scrub_val(val)}
  defp scrub_css("padding-" <> prop, val), do: validate {"padding-#{prop}", scrub_val(val)}

  defp scrub_css(_, _), do: nil

  defp validate({_property, ""}), do: nil
  defp validate({property, val}), do: {property, val}

  defp scrub_val(val) do
    val = if String.match?(val, ~r/(\\|&)/), do: "", else: val

    Regex.replace(~r/(\S+)/, val, fn _all, a ->
      if(allowed_keyword?(a) || measured_unit?(a), do: a, else: "")
    end)
  end

  @allowed_keywords ["auto", "aqua", "black", "block", "blue", "bold", "both", "bottom", "brown", "center", "collapse", "dashed", "dotted", "fuchsia", "gray", "green", "!important", "italic", "left", "lime", "maroon", "medium", "none", "navy", "normal", "nowrap", "olive", "pointer", "purple", "red", "right", "solid", "silver", "teal", "top", "transparent", "underline", "white", "yellow"]

  def allowed_keyword?(val) do
    Enum.member?(@allowed_keywords, String.downcase(val))
  end

  defp measured_unit?(val) do
    String.match?(val, ~r/\A(#[0-9a-f]+|rgb\(\d+%?,\d*%?,?\d*%?\)?|-?\d{0,2}\.?\d{0,2}(cm|em|ex|in|mm|pc|pt|px|%|,|\))?)\z/)
  end
end
