defmodule Grid.Admin.OrderController do
  use Grid.Web, :controller

  alias Grid.Order
  alias Grid.Plugs

  plug Plugs.PageTitle, title: "Orders"

  plug Plugs.AssignModel, Order when action == :show

  plug Plugs.Breadcrumb, index: Order
  plug Plugs.Breadcrumb, [show: Order] when action == :show

  def index(conn, _) do
    orders = Repo.all(Order) |> Repo.preload([:user, :order_items])
    render(conn, "index.html", orders: orders)
  end

  def show(conn, _) do
    order = conn.assigns.order
      |> Repo.preload([
        :user,
         order_items: [product: [:vendor, :experience]]
      ])
    title = "Order ##{order.id}: #{order.customer_token}"

    render(conn, "show.html", order: order, page_title: title)
  end
end
