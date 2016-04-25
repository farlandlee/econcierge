defmodule Grid.OrderStatusController do
  use Grid.Web, :controller

  import Ecto.Query

  alias Grid.{
    OrderItem,
    Repo
  }

  plug Grid.Plugs.AssignVendorToken

  def accept(conn, params), do: handle(conn, :accept, params)

  def reject(conn, params), do: handle(conn, :reject, params)

  def vendor_status(conn, _) do
    order_item = OrderItem
      |> where([oi], not is_nil(oi.status))
      |> Repo.get_by!(vendor_token: conn.assigns.vendor_token)
      |> Repo.preload(:product)

    render(conn, order_item: order_item)
  end

  defp handle(conn, status, _) do
    order_item = OrderItem |> Repo.get_by!(vendor_token: conn.assigns.vendor_token)
    {flash_type, flash_message} = change_item_status(order_item, status)

    conn
    |> put_flash(flash_type, flash_message)
    |> redirect(to: order_status_path(conn, :vendor_status, order_item.vendor_token))
  end

  defp change_item_status(%{status: item_status}, _)
  when item_status in ["rejected", "accepted"] do
    {:error, "Request has already been #{item_status}.  Please contact Outpost if you need to make changes"}
  end

  defp change_item_status(order_item, status) do
    order_item = order_item
      |> OrderItem.status_changeset(status)
      |> Repo.update!
      |> Repo.preload([
        order: :user,
        product: [:experience, :vendor, :meeting_location]
      ])

    case status do
      :accept ->
        Grid.Stripe.charge_customer(order_item)
        send_acceptance_customer(order_item)
        send_acceptance_vendor(order_item)
      :reject ->
        send_rejection_customer(order_item)
    end

    {:info, "You have successfully #{order_item.status} this request"}
  end

  def send_acceptance_customer(order_item) do
    html = Phoenix.View.render_to_string(Grid.EmailView, "request_accepted_customer.html", order_item: order_item)

    Postmark.email(
      order_item.order.user.email,
      html,
      "Request Confirmed - #{order_item.product.name}",
      "Customer Accepted"
    )
  end

  def send_acceptance_vendor(order_item) do
    html = Phoenix.View.render_to_string(Grid.EmailView, "request_accepted_vendor.html", order_item: order_item)

    Postmark.email(
      order_item.product.vendor.notification_email,
      html,
      "Request Confirmed - #{order_item.order.user.name}",
      "Vendor Accepted"
    )
  end

  def send_rejection_customer(order_item) do
    html = Phoenix.View.render_to_string(Grid.EmailView, "request_rejected_customer.html", order_item: order_item)

    Postmark.email(
      order_item.order.user.email,
      html,
      "Unable to Accommodate Request - #{order_item.product.name}",
      "Customer Rejected"
    )
  end
end
