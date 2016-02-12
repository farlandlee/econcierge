defmodule Grid.Api.AmenityOptionViewTest do
  use Grid.ConnCase

  import Grid.Api.AmenityOptionView

  test "render amenity_option" do
    amenity_option = Factory.create(:amenity_option)

    rendered_amenity_option = render("amenity_option.json", %{amenity_option: amenity_option})

    for key <- ~w(id name)a do
      assert Map.has_key?(rendered_amenity_option, key)
      assert rendered_amenity_option[key] == Map.get(amenity_option, key)
    end

    refute Map.has_key?(rendered_amenity_option, :amenity_id)
    assert Map.has_key?(rendered_amenity_option, :amenity)
    assert rendered_amenity_option.amenity == amenity_option.amenity_id
  end
end
