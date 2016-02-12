defmodule Grid.Api.ActivityViewTest do
  use Grid.ConnCase, async: true

  alias Grid.Api.ProductView

  test "render product" do
    product = Factory.create(:product) |> Grid.Api.ProductController.preload

    rendered_product = ProductView.render("product.json", %{product: product})

    # Fields taken verbatim
    for k <- ~w(id description name pickup duration)a do
      product_value = Map.get(product, k)

      assert Map.has_key?(rendered_product, k)
      rendered_value = Map.get(rendered_product, k)
      assert product_value ==  rendered_value
    end

    # Belongs to fields, id only
    for r <- ~w(vendor_id experience_id default_price_id)a do
      product_relationship_id = Map.get(product, r)

      refute Map.has_key?(rendered_product, r)

      rendered_key = r |> to_string
        |> String.split("_id")
        |> hd
        |> String.to_atom

      assert Map.has_key?(rendered_product, rendered_key)
      rendered_relationship_id = Map.get(rendered_product, rendered_key)

      assert rendered_relationship_id == product_relationship_id
    end

    # Belongs to, preloaded
    assert rendered_product.meeting_location == nil

    # Has many fields, preloaded
    for k <- ~w(prices start_times amenity_options)a do
      assert rendered_product[k] == []
    end
  end
end
