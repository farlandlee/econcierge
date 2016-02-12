defmodule Grid.Api.AmenityOptionView do
  use Grid.Web, :view

  def render("amenity_option.json", %{amenity_option: amenity_option}) do
    %{
      id: amenity_option.id,
      name: amenity_option.name,
      #activity: amenity_option.activity.id, #needs preload
      amenity: amenity_option.amenity_id,
      product: amenity_option.product_id
    }
  end
end
