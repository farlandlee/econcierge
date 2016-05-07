defmodule Grid.Api.ProductViewTest do
  use Grid.ConnCase, async: true

  alias Grid.Product
  alias Grid.Api.{
    ProductController,
    ProductView
  }

  setup do
    st = %{product: p, season: s} = Factory.create_start_time(
      season: Factory.create(:season,
        start_date: %Ecto.Date{year: 2016, month: 6, day: 1},
        end_date: %Ecto.Date{year: 2016, month: 6, day: 30}
      )
    )

    price = Factory.create(:price, product: p)
    Factory.create(:amount, price: price)

    p = Repo.update!(Product.default_price_changeset(p, price.id))
    # preloads get funky, so just load from nothing
    product = Repo.get(Product, p.id) |> ProductController.preload

    {:ok, product: product, start_time: st, season: s}
  end

  test "render product", %{product: product} do
    rendered_product = ProductView.render("product.json", %{product: product})

    # Fields taken verbatim
    for k <- ~w(id description name pickup duration)a do
      product_value = Map.get(product, k)

      assert Map.has_key?(rendered_product, k)
      rendered_value = Map.get(rendered_product, k)
      assert product_value ==  rendered_value
    end

    # Belongs to fields, id only
    for r <- ~w(vendor_id experience_id)a do
      refute Map.has_key?(rendered_product, r)

      product_relationship_id = Map.get(product, r)

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
    assert rendered_product.default_price.id == product.default_price_id
    assert rendered_product.activity == product.activity.id

    # Has many fields, preloaded
    for k <- ~w(prices start_times)a do
      assert Enum.count(rendered_product[k]) == Enum.count(Map.get(product, k))
    end

    # product_amenity_options -> amenity_options
    assert Enum.count(rendered_product.amenity_options) == Enum.count(product.product_amenity_options)
  end
end
