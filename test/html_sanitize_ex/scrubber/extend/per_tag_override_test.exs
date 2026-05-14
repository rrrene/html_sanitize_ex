defmodule PerTagOverrideTest do
  use ExUnit.Case, async: true

  defmodule TagOverrideScrubber do
    use HtmlSanitizeEx, extend: :basic_html

    allow_tag_with_these_attributes("p", ["class"])

    def scrub_attributes("p", _attributes), do: []
  end

  test "per-tag override of scrub_attributes/2 takes precedence over the default catch-all" do
    assert TagOverrideScrubber.sanitize(~s(<p class="foo">hi</p>)) == "<p>hi</p>"
  end

  test "direct call to overridden scrub_attributes/2 returns the override result" do
    assert TagOverrideScrubber.scrub_attributes("p", [{"class", "foo"}]) == []
  end

  test "non-overridden tags still use the default catch-all" do
    assert TagOverrideScrubber.scrub_attributes("a", [{"href", "https://example.com"}]) == [
             {"href", "https://example.com"}
           ]
  end
end
