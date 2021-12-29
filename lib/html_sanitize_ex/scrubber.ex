defmodule HtmlSanitizeEx.Scrubber do
  @moduledoc """
  The Scrubber module can be used to implement custom scrubbers:
  from scratch or by extending an existing scrubber.


      defmodule MyScrubber do
        use HtmlSanitizeEx.Scrubber

        extend :basic_html do
          allow_tag_with_any_attributes("p")
        end
      end

  You can extend `:basic_html`, `:html5`, `:markdown_html` and `:strip_tags` as well as any custom scrubber you created:

      defmodule FooBarScrubber do
        use HtmlSanitizeEx.Scrubber

        extend MyScrubber do
          allow_tag_with_any_attributes("header")
        end
      end

  """

  @doc false
  defmacro __using__(_opts \\ []) do
    quote do
      @before_compile HtmlSanitizeEx.Scrubber

      import HtmlSanitizeEx.Scrubber

      require HtmlSanitizeEx.Scrubber.Meta
      import HtmlSanitizeEx.Scrubber.Meta
    end

    # |> tap(fn q -> IO.puts(Code.format_string!(Macro.to_string(q))) end)
  end

  @doc """
  Used to extend an existing scrubber.

  Common reasons to do this are to ...

  - allow additional tags
  - allow additional attributes
  - allow additional attribute restrictions (e.g. URI schemes for anchors and images)

        defmodule MyScrubber do
          use HtmlSanitizeEx.Scrubber

          extend HtmlSanitizeEx.Scrubber.BasicHTML do
            allow_tag_with_any_attributes("p")
          end
        end

  """
  defmacro extend(mod, opts \\ nil)

  defmacro extend(:noscrub, opts),
    do: do_extend(HtmlSanitizeEx.Scrubber.NoScrub, opts)

  defmacro extend(:basic_html, opts),
    do: do_extend(HtmlSanitizeEx.Scrubber.BasicHTML, opts)

  defmacro extend(:html5, opts),
    do: do_extend(HtmlSanitizeEx.Scrubber.HTML5, opts)

  defmacro extend(:markdown_html, opts),
    do: do_extend(HtmlSanitizeEx.Scrubber.MarkdownHTML, opts)

  defmacro extend(:strip_tags, opts),
    do: do_extend(HtmlSanitizeEx.Scrubber.StripTags, opts)

  defmacro extend(mod, opts), do: do_extend(mod, opts)

  defp do_extend(mod, opts) do
    do_block = opts[:do] || quote(do: nil)

    # IO.puts("\nextend\n")

    quote do
      @fallback_module unquote(mod)

      unquote(do_block)
    end

    # |> tap(fn q ->
    #   IO.puts("### extend ###\n")
    #   IO.puts(Code.format_string!(Macro.to_string(q)))
    # end)
  end

  defmacro __before_compile__(env) do
    fallback_module =
      Module.get_attribute(
        env.module,
        :fallback_module,
        HtmlSanitizeEx.Scrubber.StripTags
      )

    allowed_tag_names =
      Module.get_attribute(
        env.module,
        :allowed_tag_names,
        []
      )
      |> Enum.uniq()

    allowed_tag_name_scrubs =
      Enum.map(allowed_tag_names, fn tag_name ->
        quote do
          def scrub({unquote(tag_name), attributes, children}) do
            {unquote(tag_name), scrub_attributes(unquote(tag_name), attributes),
             children}
          end

          defp scrub_attributes(unquote(tag_name), attributes) do
            Enum.map(attributes, fn attr ->
              scrub_attribute(unquote(tag_name), attr)
            end)
            |> Enum.reject(&is_nil(&1))
          end
        end
      end)

    quote do
      unquote(allowed_tag_name_scrubs)

      def before_scrub(html), do: fallback_before_scrub(html)

      def scrub_attribute(tag, attribute),
        do: fallback_scrub_attribute(tag, attribute)

      def scrub(text), do: fallback_scrub(text)

      defp fallback_before_scrub(html) do
        # IO.inspect(:before_scrub)
        unquote(fallback_module).before_scrub(html)
      end

      defp fallback_scrub_attribute(tag, attribute) do
        # IO.inspect({:scrub_attribute, tag, attribute}, label: "FALLBACK")
        unquote(fallback_module).scrub_attribute(tag, attribute)
      end

      defp fallback_scrub(text) do
        # IO.inspect({:scrub, text}, label: "FALLBACK")
        unquote(fallback_module).scrub(text)
      end
    end

    # |> tap(fn q ->
    #   IO.puts("### __before_compile__ ###\n")
    #   IO.puts(Code.format_string!(Macro.to_string(q)))
    # end)
  end

  #
  #

  def scrub(html, scrubber_module)

  def scrub("", _) do
    ""
  end

  def scrub(nil, _) do
    ""
  end

  def scrub(html, scrubber_module) do
    html
    |> scrubber_module.before_scrub
    |> HtmlSanitizeEx.Parser.parse()
    |> HtmlSanitizeEx.Traverser.traverse(scrubber_module)
    |> HtmlSanitizeEx.Parser.to_html()
  end
end
