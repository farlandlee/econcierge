defmodule Grid.Api.OrderView do
  use Grid.Web, :view

  def render("show.json", %{order: order}) do
    %{order: render_one(order, Grid.Api.OrderView, "order.json")}
  end

  def render("order.json", %{order: %{customer_token: customer_token}}) do
    %{customer_token: customer_token}
  end
end
