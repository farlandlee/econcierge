defmodule Grid.Api.VendorView do
  use Grid.Web, :view

  def render("index.json", %{vendors: vendors}) do
    %{vendors: render_many(vendors, Grid.Api.VendorView, "vendor.json")}
  end

  def render("show.json", %{vendor: vendor}) do
    %{vendor: render_one(vendor, Grid.Api.VendorView, "vendor.json")}
  end

  def render("vendor.json", %{vendor: vendor}) do
    %{
      id: vendor.id,

      name: vendor.name,
      description: vendor.description,
      slug: vendor.slug,

      cancellation_policy_days: vendor.cancellation_policy_days,

      tripadvisor_rating: vendor.tripadvisor_rating,
  
      default_image: render_one(vendor.default_image, Grid.Api.ImageView, "image.json")
    }
  end
end
