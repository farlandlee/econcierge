defmodule Grid.Api.AmenityView do
  use Grid.Web, :view

  alias Grid.Api.AmenityOptionView

  def render("amenity.json", %{amenity: amenity}) do
    %{
      id: amenity.id,
      name: amenity.name,
      options: render_many(amenity.amenity_options, AmenityOptionView, "amenity_option.json")
    }
  end
end
