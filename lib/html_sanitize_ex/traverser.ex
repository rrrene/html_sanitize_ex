defmodule HtmlSanitizeEx.Traverser do
  @doc """
    Traverses an html_tree.
  """
  def traverse([], _scrubber_module) do
    []
  end

  def traverse([head | tail], scrubber_module) do
    head = traverse(head, scrubber_module) |> collapse_list
    tail = traverse(tail, scrubber_module)

    result = List.flatten([head] ++ tail)

    #IO.inspect {:head, head}
    #IO.inspect {:tail, tail}
    #IO.inspect {:result, result}
    result
  end

  def traverse({tag, attributes, children}, scrubber_module) do
    children = children |> traverse(scrubber_module)
    {tag, attributes, children}
    |> scrubber_module.scrub
  end

  def traverse(text, scrubber_module) when is_binary(text) do
    text
    |> scrubber_module.scrub
  end

  # Matches things like {:comment, "this is a comment"} or {:doctype, "..."}.
  def traverse({token, children}, scrubber_module) do
    children =
      children
      |> traverse(scrubber_module)
      |> collapse_list

    {token, children}
    |> scrubber_module.scrub
  end

  # Matches things like {:comment, "this is a comment"} or {:doctype, "..."}.
  def traverse(what, _scrubber_module) do
    #IO.inspect "########################"
    #IO.inspect {:error, what}
    #IO.inspect "########################"
    what
  end

  # Collapses a list if it only consists of other lists.
  defp collapse_list(children) do
    result = case children do
      [single] -> single
      list -> list
    end
    result
  end
end
