defmodule Grid.AdminView do
  use Grid.Web, :view

  @doc """
  Takes two ids and a path.
  If the ids are the same, outputs a button that does nothing.
  If the ids are different, outputs a link to path for setting the default
  """
  def default_switcher(a, a, _) do
    content_tag :button, "Current default",
      class: "btn btn-primary btn-sm active",
      disabled: "disabled"
  end
  def default_switcher(_, _, path) do
    link "Set as default",
      to: path,
      method: :put,
      class: "btn-sm btn-primary"
  end

  def ids(items) when is_list(items) do
    Enum.map(items, &(&1.id))
  end
  def ids(_), do: []

  def pretty_name_list(items) do
    items
    |> Enum.map(&(&1.name))
    |> Enum.join(" | ")
  end
end
