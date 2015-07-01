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

  @spec parse(binary) :: html_tree

  def parse(html) do
    html = "<#{@my_root_node}>#{html}</#{@my_root_node}>"
    {@my_root_node, [], parsed} = :mochiweb_html.parse(html)

    if length(parsed) == 1, do: hd(parsed), else: parsed
  end

  def to_html(tokens) do
    {@my_root_node, [], ensure_list(tokens)}
      |> :mochiweb_html.to_html
      |> Enum.join
      |> String.replace(~r/^<#{@my_root_node}>/, "")
      |> String.replace(~r/<\/#{@my_root_node}>$/, "")
      |> String.replace("&lt;/html_sanitize_ex&gt;", "")
  end

  defp ensure_list(list) do
    case list do
      [head | tail] -> list
      _ -> [list]
    end
  end
end
