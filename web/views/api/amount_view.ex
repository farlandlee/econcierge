defmodule Grid.Api.AmountView do
  use Grid.Web, :view

  def render("amount.json", %{amount: amount}) do
    %{
      id: amount.id,
      price: amount.price_id,
      amount: amount.amount,
      min_quantity: amount.min_quantity,
      max_quantity: amount.max_quantity
    }
  end
end
