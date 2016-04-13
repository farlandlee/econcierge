defmodule Grid.Api.ProductView do
  use Grid.Web, :view

  alias Grid.Api.{
    LocationView,
    PriceView,
    StartTimeView,
    ImageView
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

  def render("product.json", %{product: product = %{default_price_id: default_price_id}}) do
    default_price = Enum.find(product.prices, :error, &match?(%{id: ^default_price_id}, &1))

    %{
      id: product.id,
      description: product.description,
      name: product.name,
      pickup: product.pickup,
      duration: product.duration,

      vendor: product.vendor_id,
      experience: product.experience_id,
      default_price: render_one(default_price, PriceView, "price.json"),

      meeting_location: render_one(product.meeting_location, LocationView, "location.json"),
      prices: render_many(product.prices, PriceView, "price.json"),
      start_times: render_many(product.start_times, StartTimeView, "start_time.json"),
      images: render_many(product.images, ImageView, "image.json"),
      amenity_options: Enum.map(product.product_amenity_options, &(&1.amenity_option_id))
    }
  end
end
