defmodule Grid.Admin.Vendor.ProductView do
  use Grid.Web, :view

  def activity_category_ids(%{model: %{activity_categories: activity_categories}}) when is_list(activity_categories) do
    Enum.map(activity_categories, &(&1.id))
  end
  def activity_category_ids(_), do: []
end
