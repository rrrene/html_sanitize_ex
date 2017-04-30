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
  @linebreak [239, 188, 191]

  @spec parse(binary) :: html_tree

  def parse(html) do
    html = "<#{@my_root_node}>#{before_parse(html)}</#{@my_root_node}>"
    {@my_root_node, [], parsed} = :mochiweb_html.parse(html)

    if length(parsed) == 1, do: hd(parsed), else: parsed
  end

  defp before_parse(html) do
    String.replace(html, ~r/(>)(\r?\n)/, "\\1 #{@linebreak} \\2")
  end

  def to_html(tokens) do
    {@my_root_node, [], ensure_list(tokens)}
    |> :mochiweb_html.to_html
    |> Enum.join
    |> String.replace(~r/^<#{@my_root_node}>/, "")
    |> String.replace(~r/<\/#{@my_root_node}>$/, "")
    |> String.replace("&lt;/html_sanitize_ex&gt;", "")
    |> after_to_html()
  end

  defp after_to_html(html) do
    String.replace(html, ~r/(\ ?#{@linebreak} )(\r?\n)/, "\\2")
  end

  defp ensure_list(list) do
    case list do
      [_head | _tail] -> list
      _ -> [list]
    end
  end
end
