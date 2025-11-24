# Changelog

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
