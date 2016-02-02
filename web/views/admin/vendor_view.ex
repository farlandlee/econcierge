defmodule Grid.Admin.VendorView do
  use Grid.Web, :view
  import Grid.AdminView, only: [tab_link: 1]

  def active_filter_class(filter, activity)
  def active_filter_class(%{id: id}, %{id: id}), do: "active"
  def active_filter_class(_, _), do: ""

end
