defmodule Grid.Admin.Vendor.Product.ImageView do

  def render(template, assigns) do
    assigns = assigns
      |> Map.put(:image_path, :admin_vendor_product_image_path)
      |> Map.put(:ancestor_path, :admin_vendor_product_path)
      |> Map.put(:ancestors, [assigns.vendor, assigns.product])
      |> Map.delete(:product)

    Grid.Admin.ImageView.render(template, assigns)
  end
end
