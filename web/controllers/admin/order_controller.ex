defmodule Grid.Admin.OrderController do
  use Grid.Web, :controller

  alias Grid.{
    Repo,
    Order,
    OrderItem,
    Plugs
  }

  plug Plugs.PageTitle, title: "Orders"

  plug Plugs.AssignModel, Order when action == :show

  plug Plugs.Breadcrumb, index: Order
  plug Plugs.Breadcrumb, [show: Order] when action == :show

  plug Plugs.AssignVendorToken when action == :find_order_item

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

  def find_order_item(conn, _) do
    case Repo.get_by(OrderItem, vendor_token: conn.assigns.vendor_token) do
      nil ->
        conn
        |> put_flash(:error, "Could not find order item with reference id: #{conn.assigns.vendor_token}")
        |> redirect(to: admin_dashboard_path(conn, :index))
      oi ->
        redirect(conn, to: admin_order_path(conn, :show, oi.order_id))
    end
  end
end
