defmodule HtmlSanitizeEx.Scrubber do
  @moduledoc """
  The Scrubber module can be used to implement custom scrubbers:
  from scratch or by extending an existing scrubber.


      defmodule MyScrubber do
        use HtmlSanitizeEx.Scrubber

        extend HtmlSanitizeEx.Scrubber.BasicHTML do
          allow_tag_with_any_attributes("p")
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
  defmacro extend(mod, opts \\ nil) do
    do_block = opts[:do] || quote(do: nil)

    quote do
      @fallback_module unquote(mod)

      unquote(do_block)
    end

    # |> tap(fn q -> IO.puts(Code.format_string!(Macro.to_string(q))) end)
  end

  defmacro __before_compile__(env) do
    fallback_module =
      Module.get_attribute(
        env.module,
        :fallback_module,
        HtmlSanitizeEx.Scrubber.StripTags
      )

    quote do
      def before_scrub(html) do
        IO.inspect(:before_scrub)
        unquote(fallback_module).before_scrub(html)
      end

      def scrub_attribute(tag, attribute) do
        IO.inspect({:scrub_attribute, tag, attribute})
        unquote(fallback_module).scrub_attribute(tag, attribute)
      end

      def scrub(text) do
        IO.inspect({:scrub, text})
        unquote(fallback_module).scrub(text)
      end
    end

    # |> tap(fn q -> IO.puts(Code.format_string!(Macro.to_string(q))) end)
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
