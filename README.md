# HtmlSanitizeEx

`html_sanitize_ex` provides a fast and straightforward HTML Sanitizer written in Elixir which lets you include HTML authored by third-parties in your web application while protecting against XSS.

It is the first Hex package to come out of the [elixirstatus.com](http://elixirstatus.com) project, where it will be used to sanitize user annoucements from the Elixir community.



## What can it do?

`html_sanitize_ex` parses a given HTML string and, based on the used [Scrubber](https://github.com/rrrene/html_sanitize_ex/tree/master/lib/html_sanitize_ex/scrubber), either completely strips it from HTML tags or sanitizes it by only allowing certain HTML elements and attributes to be present.



## Installation

Add html_sanitize_ex as a dependency in your `mix.exs` file.

```elixir
defp deps do
  [{:html_sanitize_ex, "~> 0.1.0"}]
end
```

After adding you are done, run `mix deps.get` in your shell to fetch the new dependency.  

The only dependency of `html_sanitize_ex` is `mochiweb` which is used to parse HTML.


## Usage

It can strip all tags from the given string:

    text = "<a href=\"javascript:alert('XSS');\">text here</a>"
    HtmlSanitizeEx.strip_tags(text)
    # => "text here"

Or allow certain basic HTML elements to remain:

    text = "<h1>Hello <script>World!</script></h1>"
    HtmlSanitizeEx.basic_html(text)
    # => "<h1>Hello World!</h1>"

**TODO: write more comprehensive usage description**


## Contributing

1. [Fork it!](http://github.com/rrrene/html_sanitize_ex/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request



## Author

René Föhring (@rrrene)




## License

html_sanitize_ex is released under the MIT License. See the LICENSE file for further
details.
