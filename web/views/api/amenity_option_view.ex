defmodule Grid.Api.AmenityOptionView do
  use Grid.Web, :view

  def render("amenity_option.json", %{amenity_option: amenity_option}) do
    %{
      id: amenity_option.id,
      name: amenity_option.name,
      amenity: amenity_option.amenity_id
    }
  end
end
