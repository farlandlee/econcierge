defmodule Grid.AdminView do
  use Grid.Web, :view

  def environment_tag do
    {class, text} = case Grid.get_env(:env) do
      :prod -> {"text-success", "Production"}
      :dev -> {"", "Development"}
      :test -> {"text-primary", "Test"}
      :staging -> {"text-primary", "Staging"}
      _ -> {"text-warning", "Unknown Environment"}
    end
    content_tag :span, text, class: class
  end

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

  def tab_link(target) do
    lowercase = String.downcase(target)
    link target, to: "#" <> lowercase, class: "grid-tab"
  end
end
