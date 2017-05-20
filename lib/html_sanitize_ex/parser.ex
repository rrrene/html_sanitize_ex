defmodule HtmlSanitizeEx.Parser do  @doc """
  Parses a HTML string.
  ## Examples
      iex> Floki.parse("<div class=js-action>hello world</div>")
      {"div", [{"class", "js-action"}], ["hello world"]}
      iex> Floki.parse("<div>first</div><div>second</div>")
      [{"div", [], ["first"]}, {"div", [], ["second"]}]
  """

  @type html_tree :: tuple | list

  @my_root_node "html_sanitize_ex"
  @replacement_linebreak [239, 188, 191]
  @replacement_space [239, 189, 191]
  @replacement_tab [239, 190, 191]

  @spec parse(binary) :: html_tree

  def parse(html) do
    html = "<#{@my_root_node}>#{before_parse(html)}</#{@my_root_node}>"
    {@my_root_node, [], parsed} = :mochiweb_html.parse(html)

    if length(parsed) == 1, do: hd(parsed), else: parsed
  end

  defp before_parse(html) do
    html
    |> String.replace(~r/(>)(\r?\n)/, "\\1 #{@replacement_linebreak} \\2")
    |> String.replace(~r/(>)(\ +)(<)/, "\\1 #{@replacement_space}\\2\\3")
    |> String.replace(~r/(>)(\t+)(<)/, "\\1 #{@replacement_tab}\\2\\3")
  end

  def to_html(tokens) do
    {@my_root_node, [], List.wrap(tokens)}
    |> :mochiweb_html.to_html
    |> Enum.join
    |> String.replace(~r/^<#{@my_root_node}>/, "")
    |> String.replace(~r/<\/#{@my_root_node}>$/, "")
    |> String.replace("&lt;/html_sanitize_ex&gt;", "")
    |> after_to_html()
  end

  defp after_to_html(html) do
    html
    |> String.replace(~r/(\ ?#{@replacement_linebreak} )(\r?\n)/, "\\2")
    |> String.replace(~r/(\&gt\;|>)(\ +)(#{@replacement_space})(\ +)(\&lt\;|<)/, "\\1\\4\\5")
    |> String.replace(~r/(\&gt\;|>)(\ +)(#{@replacement_tab})(\t+)(\&lt\;|<)/, "\\1\\4\\5")
  end

  @doc false
  def replacement_for_linebreak, do: @replacement_linebreak

  @doc false
  def replacement_for_space, do: @replacement_space

  @doc false
  def replacement_for_tab, do: @replacement_tab
end
