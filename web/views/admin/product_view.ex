defmodule Grid.Admin.Vendor.ProductView do
  use Grid.Web, :view

  def activity_category_ids(%{model: %{activity_categories: activity_categories}}) when is_list(activity_categories) do
    Enum.map(activity_categories, &(&1.id))
  end
  def activity_category_ids(_), do: []

  def check_icon(true), do: check_icon("check")
  def check_icon(false), do: check_icon("unchecked")
  def check_icon(class) do
    tag :span, class: "glyphicon glyphicon-#{class}"
  end
end
