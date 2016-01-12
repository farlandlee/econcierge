defmodule Grid.Admin.SharedHelpers do
  def ids(items) when is_list(items) do
    Enum.map(items, &(&1.id))
  end
  def ids(_), do: []

  def pretty_activities(activities) do
    activities
    |> Enum.map(&(&1.name))
    |> Enum.join(" | ")
  end

  def pretty_name_list(items) do
    items
    |> Enum.map(&(&1.name))
    |> Enum.join(" | ")
  end
end
