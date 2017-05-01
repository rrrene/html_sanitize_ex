defmodule HtmlSanitizeExScrubberNoScrubTest do
  use ExUnit.Case

  defp no_scrub_sanitize(text) do
    HtmlSanitizeEx.noscrub(text)
  end

  test "strips nothing" do
    input = "This <b>is</b> <b>an</b> <i>example</i> of <u>space</u> eating."
    assert input == no_scrub_sanitize(input)
  end

  test "leaves white-space between nodes intact" do
    input = "This <b>is</b>\n<b>an</b> <i>example</i> of\n\n<u>space</u> eating."
    assert input == no_scrub_sanitize(input)
  end

  test "leaves white-space between nodes intact (CR)" do
    input = "This <b>is</b>\n<b>an</b> <i>example</i> of\r\n\r\n<u>space</u> eating."
    assert input == no_scrub_sanitize(input)
  end

  test "leaves white-space between nodes intact (tabs)" do
    input = "This <b>is</b>\t<b>an</b> <i>example</i> of\t\t<u>space</u> eating."
    assert input == no_scrub_sanitize(input)
  end
end
