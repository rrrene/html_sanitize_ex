defmodule HtmlSanitizeExScrubberNoScrubTest do
  use ExUnit.Case

  defp no_scrub_sanitize(text) do
    HtmlSanitizeEx.noscrub(text)
  end

  test "strips nothing" do
    input = "This <b>is</b> <b>an</b> <i>example</i> of <u>space</u> eating."
    expected = "This <b>is</b> <b>an</b> <i>example</i> of <u>space</u> eating."
    assert expected == no_scrub_sanitize(input)
  end
end
