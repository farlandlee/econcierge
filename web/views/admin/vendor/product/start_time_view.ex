defmodule Grid.Admin.Vendor.Product.StartTimeView do
  use Grid.Web, :view

  defdelegate season_text(s),
    to: Grid.Admin.Vendor.VendorActivity.SeasonView,
    as: :text
end
