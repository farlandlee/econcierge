defmodule Grid.Api.AmountViewTest do
  use Grid.ConnCase

  import Grid.Api.AmountView

  test "render amount" do
    amount = Factory.create(:amount)

    rendered_amount = render("amount.json", %{amount: amount})

    for key <- ~w(id amount min_quantity max_quantity)a do
      assert Map.has_key?(rendered_amount, key)
      assert rendered_amount[key] == Map.get(amount, key)
    end

    assert Map.has_key?(rendered_amount, :price)
    assert rendered_amount.price == amount.price_id
  end
end
