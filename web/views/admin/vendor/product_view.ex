defmodule Grid.Admin.Vendor.ProductView do
  use Grid.Web, :view

  def check_icon(true), do: check_icon("check")
  def check_icon(false), do: check_icon("unchecked")
  def check_icon(class) do
    tag :span, class: "glyphicon glyphicon-#{class}"
  end

  def vendor_or_experience_header(:vendor),     do: "Vendor"
  def vendor_or_experience_header(:experience), do: "Experience"

  def vendor_or_experience(:vendor, product) do
    vendor = product.vendor
    link(vendor.name, to: admin_vendor_path(Grid.Endpoint, :show, vendor))
  end
  def vendor_or_experience(:experience, product) do
    experience = product.experience
    link(experience.name,
      to: admin_activity_experience_path(Grid.Endpoint, :show, experience.activity_id, experience)
    )
  end
end
