defmodule Grid.Admin.VendorView do
  use Grid.Web, :view

  def activity_ids(%{model: %{activity: activities}}) when is_list(activities) do
    Enum.map(activities, &(&1.id))
  end
  def activity_ids(_), do: []

  def pretty_activities(activities) do
    activities
    |> Enum.map(&(&1.name))
    |> Enum.join(" | ")
  end

  # stolen from phoenix_html
  defp value_from(%{model: model, params: params}, field) do
    case Map.fetch(params, Atom.to_string(field)) do
      {:ok, value} -> value
      :error -> Map.get(model, field)
    end
  end

end
