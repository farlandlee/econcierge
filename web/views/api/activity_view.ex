defmodule Grid.Api.ActivityView do
  use Grid.Web, :view

  alias Grid.Api.AmenityView

  def render("index.json", %{activities: activities}) do
    %{activities: render_many(activities, __MODULE__, "activity.json")}
  end

  def render("show.json", %{activity: activity}) do
    %{activity: render_one(activity, __MODULE__, "activity.json")}
  end

  def render("activity.json", %{activity: activity}) do
    %{
      id: activity.id,
      name: activity.name,
      description: activity.description,
      slug: activity.slug,
      use_product_photo_card: activity.use_product_photo_card,
      default_image: render_one(activity.default_image, Grid.Api.ImageView, "image.json"),
      amenities: render_many(activity.amenities, AmenityView, "amenity.json")
    }
  end
end
