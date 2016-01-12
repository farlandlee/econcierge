defmodule Grid.Admin.VendorView do
  use Grid.Web, :view

  def activity_ids(%{model: %{activities: activities}}) when is_list(activities) do
    Enum.map(activities, &(&1.id))
  end
  def activity_ids(_), do: []

  def pretty_activities(activities) do
    activities
    |> Enum.map(&(&1.name))
    |> Enum.join(" | ")
  end

end
