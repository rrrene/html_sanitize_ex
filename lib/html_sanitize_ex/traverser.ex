defmodule HtmlSanitizeEx.Traverser do
  @doc """
    Traverses an html_tree.
  """
  def traverse(list, scrubber_module) when is_list(list) do
    Enum.reduce(list, [], fn
      head, acc ->
        elem = traverse(head, scrubber_module) |> collapse_list
        [elem | acc]
    end)
    |> Enum.reverse()
    |> List.flatten()
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
    # IO.inspect "########################"
    # IO.inspect {:error, what}
    # IO.inspect "########################"
    what
  end

  # Collapses a list if it only consists of other lists.
  defp collapse_list(children) do
    result =
      case children do
        [single] -> single
        list -> list
      end

    result
  end
end
