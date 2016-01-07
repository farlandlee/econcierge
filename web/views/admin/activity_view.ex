defmodule Grid.Admin.ActivityView do
  use Grid.Web, :view

  def category_ids(%{model: %{categories: categories}}) when is_list(categories) do
    Enum.map(categories, &(&1.id))
  end
  def category_ids(_), do: []

  def activity_img(form_or_image, opts \\ []) do
    Grid.Admin.VendorView.vendor_img(form_or_image, opts)
  end
end
