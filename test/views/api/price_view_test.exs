defmodule Grid.Api.PriceViewTest do
  use Grid.ConnCase

  import Grid.Api.PriceView

  test "render price" do
    %{price: price} = Factory.create(:amount)
    price = Repo.preload(price, :amounts)
    rendered_price = render("price.json", %{price: price})

    for key <- ~w(id name description people_count)a do
      assert Map.has_key?(rendered_price, key)
      assert rendered_price[key] == Map.get(price, key)
    end
    refute Map.has_key?(rendered_price, :product_id)
    assert Map.has_key?(rendered_price, :product)
    assert rendered_price.product == price.product_id

    assert Map.has_key?(rendered_price, :amounts)
    assert Enum.count(rendered_price.amounts) == 1
  end
end
