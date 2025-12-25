# Changelog

## 1.5.0


### New API for Custom Scrubbers

Instead of importing and requiring `HtmlSanitizeEx.Scrubber.Meta`, just use `HtmlSanitizeEx`:

```elixir
defmodule MyScrubber do
  use HtmlSanitizeEx

  allow_tag_with_these_attributes("p", ["title"])
end
```

Using `HtmlSanitizeEx` also creates a `sanitize/1` function in the module, so you can just call `MyScrubber.sanitize(html)`.


`allow_tag_with_these_attributes/3` is taking a `do` block, which allows specific handling of `attribute`/`value` pairs:

```elixir
defmodule MyScrubber do
  use HtmlSanitizeEx

  allow_tag_with_these_attributes("p", ["title"]) do
    {"class", value} when value in ["red", "green", "blue"] ->
      {"class", value}
  end
end
```

The handler either returns a `{attribute, value}` pair or `nil` to scrub the value.


### Extending existing Scrubbers

`HtmlSanitizeEx` can also be used for extending existing scrubbers:

```elixir
defmodule MyScrubber do
  use HtmlSanitizeEx, extend: :basic_html

  allow_tag_with_these_attributes("p", ["title"])
end
```

You can extend `:basic_html`, `:html5`, `:markdown_html` and `:strip_tags`.

You can also extend any custom scrubber you created:

```elixir
defmodule MyOtherScrubber do
  use HtmlSanitizeEx, extend: MyScrubber

  allow_tag_with_these_attributes("p", ["class"])
end
```

The result is a scrubber that works like the built-in BasicHTML scrubber, but also allows `class` and `title` attributes on `<p>` tags.

## 1.4.4

- Fix compatibility & compiler warnings with Elixir 1.19
- Update `mochiweb` to version 3.2.2 in `mix.lock` for OTP 27 compatibility
- Add missing `<details>` tag to `HTML5` scrubber

## 1.4.3

- Allow `mochiweb` dep to be `~> 2.15 or ~> 3.1`

## 1.4.2

- Fix regression when parsing schemes from URIs
- Fix compiler warnings
- Add missing `<body>` tag to `HTML5` scrubber

## 1.4.1

- Add missing `<h6>` tag to `BasicHTML` and `MarkdownHTML` scrubbers

## 1.4.0

- Add more missing HTML5 attributes
- Add "middle" to valid CSS keywords

## 1.3.0

- Add valid scheme for links: `mailto`
- Update white-space handling in order to keep more of it untouched

## 1.2.0

- Update `mochiweb` version requirement
- Fix missing elements in HTML5: div, caption

## 1.1.1

- Fix missing element in HTML5: blockquote

## 1.1.0

- Add new scrubber: MarkdownHTML

  It is meant to scrub HTML that resulted from converting Markdown to HTML. It
  supports GitHub flavored Markdown (GFM).

## 1.0.1

- Fix Elixir 1.3 compiler warnings

## 1.0.0

- First release
