defmodule Grid.OrderStatusController do
  use Grid.Web, :controller

  import Ecto.Query

  alias Grid.{
    OrderItem,
    Repo,
    Vendor
  }

  def accept(conn, params), do: handle(conn, :accept, params)

  def reject(conn, params), do: handle(conn, :reject, params)

  def vendor_status(conn, %{"vendor_token" => vt}) do
    order_item = OrderItem
      |> where([oi], not is_nil(oi.status))
      |> Repo.get_by!(vendor_token: vt)
      |> Repo.preload(:product)

    render(conn, order_item: order_item)
  end

  defp handle(conn, status, %{"vendor_token" => vt}) do
    order_item =
      OrderItem
      |> Repo.get_by!(vendor_token: vt)

    handle(conn, status, order_item)
  end
  defp handle(conn, status, %OrderItem{status: nil} = order_item) do
    order_item =
      OrderItem.status_changeset(order_item, status)
      |> Repo.update!

    handle_transition(status, order_item)

    conn
    |> put_flash(:info, "You have successfully #{order_item.status} this request")
    |> redirect(to: order_status_path(conn, :vendor_status, order_item.vendor_token))
  end
  defp handle(conn, _status, %OrderItem{} = order_item) do
    conn
    |> put_flash(:error, "Request has already been #{order_item.status}.  Please contact Outpost if you need to make changes")
    |> redirect(to: order_status_path(conn, :vendor_status, order_item.vendor_token))
  end

  defp handle_transition(:accept, %OrderItem{} = order_item) do
    Grid.Stripe.charge_customer(order_item)

    order_item = Repo.preload(order_item, [order: :user, product: [:vendor, :experience, :meeting_location]])
    send_acceptance_customer(order_item)
    send_acceptance_vendor(order_item)
  end

  defp handle_transition(:reject, %OrderItem{} = order_item) do
    order_item = Repo.get!(OrderItem, order_item.id)
      |> Repo.preload([order: :user, product: [:experience, :vendor, :meeting_location]])

    send_rejection_customer(order_item)
  end

  def send_acceptance_customer(%OrderItem{} = order_item) do
    html = Phoenix.View.render_to_string(Grid.EmailView, "request_accepted_customer.html", order_item: order_item)

    Postmark.email(
      order_item.order.user.email,
      html,
      "Request Confirmed - #{order_item.product.name}",
      "Customer Accepted",
      Mix.env
    )
  end

  def send_acceptance_vendor(%OrderItem{} = order_item) do
    html = Phoenix.View.render_to_string(Grid.EmailView, "request_accepted_vendor.html", order_item: order_item)

    Postmark.email(
      Vendor.email(order_item.product.vendor),
      html,
      "Request Confirmed - #{order_item.order.user.name}",
      "Vendor Accepted",
      Mix.env
    )
  end

  def send_rejection_customer(%OrderItem{} = order_item) do
    html = Phoenix.View.render_to_string(Grid.EmailView, "request_rejected_customer.html", order_item: order_item)

    Postmark.email(
      order_item.order.user.email,
      html,
      "Unable to Accommodate Request - #{order_item.product.name}",
      "Customer Rejected",
      Mix.env
    )
  end

end
