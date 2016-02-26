defmodule Grid.Api.PriceView do
  use Grid.Web, :view

  alias Grid.Api.AmountView

  def render("price.json", %{price: price}) do
    %{
      id: price.id,
      name: price.name,
      description: price.description,
      people_count: price.people_count,
      product: price.product_id,
      amounts: render_many(price.amounts, AmountView, "amount.json")
    }
  end
end
