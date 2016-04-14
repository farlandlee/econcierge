defmodule Grid.Admin.Vendor.ImageView do

  def render(template, assigns) do
    assigns = assigns
      |> Map.put(:image_path, :admin_vendor_image_path)
      |> Map.put(:ancestor_path, :admin_vendor_path)
      |> Map.put(:ancestors, [assigns.vendor])
      |> Map.delete(:vendor)
    Grid.Admin.ImageView.render(template, assigns)
  end
end
