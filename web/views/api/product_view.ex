defmodule Grid.Api.ProductView do
  use Grid.Web, :view

  alias Grid.Api.{
    LocationView,
    PriceView,
    StartTimeView,
    AmenityOptionView
  }

  def render("index.json", %{products: products}) do
    %{products: render_many(products, __MODULE__, "product.json")}
  end

  def render("show.json", %{product: product}) do
    %{product: render_one(product, __MODULE__, "product.json")}
  end

  def render("product.json", %{product: %{published: false}}) do
    raise ArgumentError, message: "Cannot render unpublished product"
  end

  def render("product.json", %{product: product}) do
    %{
      id: product.id,
      description: product.description,
      name: product.name,
      pickup: product.pickup,
      duration: product.duration,

      vendor: product.vendor_id,
      experience: product.experience_id,
      default_price: product.default_price_id,

      meeting_location: render_one(product.meeting_location, LocationView, "location.json"),
      prices: render_many(product.prices, PriceView, "price.json"),
      start_times: render_many(product.start_times, StartTimeView, "start_time.json"),
      amenity_options: render_many(product.amenity_options, AmenityOptionView, "amenity_option.json")
    }
  end
end