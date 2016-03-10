defmodule Grid.Api.OrderController do
  use Grid.Web, :controller

  alias Grid.{
    Order,
    OrderItem,
    User,
    Vendor
  }

  plug :load_customer when action in [:process_cart]
  plug :load_cart when action in [:process_cart]
  plug :prepare_order_params when action in [:process_cart]

  def process_cart(conn, %{"stripe_token" => stripe_token}) do
    changeset = Order.creation_changeset(conn.assigns.order_params, conn.assigns.customer.id)

    case Repo.insert(changeset) do
      {:ok, order} ->
        Grid.Stripe.link_customer(conn.assigns.customer, stripe_token)
        send_for_order(order.id)

        conn
        |> put_status(:created)
        |> render("show.json", order: order)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Grid.ErrorView, "422.json", changeset: changeset)
    end
  end

  ###########
  ## Plugs ##
  ###########

  def load_customer(conn, _) do
    user_params = conn.params["user"]
    do_load_customer(conn, user_params)
  end

  def load_cart(conn, _) do
    case conn.params["cart"] do
      cart = [_|_] -> assign(conn, :cart, cart)
      _ -> halt_422(conn, ["No items in cart"])
    end
  end

  def prepare_order_params(conn, _) do
    case Grid.Cart.to_order_params(conn.assigns.cart) do
      {:ok, params} -> assign(conn, :order_params, params)
      {:error, error} -> halt_422(conn, [error])
    end
  end

  defp do_load_customer(conn, %{"email" => email} = user_params) do
    changeset = case Repo.get_by(User, email: email) do
      nil  -> User.changeset(%User{}, user_params)
      user -> User.changeset(user, user_params)
    end

    case Repo.insert_or_update(changeset) do
      {:ok, user} -> assign(conn, :customer, user)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Grid.ErrorView, "422.json", changeset: changeset)
        |> halt
    end
  end
  defp do_load_customer(conn, %{}) do
    halt_422(conn, ["No user in payload"])
  end
  defp do_load_customer(conn, nil), do: do_load_customer(conn, %{})

  def halt_422(conn, errors) do
    conn
    |> put_status(:unprocessable_entity)
    |> json(%{cart_errors: errors})
    |> halt
  end

  ############
  ## Emails ##
  ############

  def send_for_order(order_id) do
    order =
      Repo.get(Order, order_id)
      |> Repo.preload([:user, [order_items: [product: [:vendor, :experience, :meeting_location]]]])

    send_request_received(order)
    Enum.each(order.order_items, &(send_vendor_notice(&1)))
  end

  def send_request_received(%Order{} = order) do
    html = Phoenix.View.render_to_string(Grid.EmailView, "request_received_customer.html", order: order)

    Postmark.email(
      order.user.email,
      html,
      "Your booking requests have been submitted",
      "Customer Request"
    )
  end

  def send_vendor_notice(%OrderItem{} = oi) do
    html = Phoenix.View.render_to_string(Grid.EmailView, "request_received_vendor.html", order_item: oi)

    Postmark.email(
      Vendor.email(oi.product.vendor),
      html,
      "New Booking Request - #{oi.product.name}",
      "Vendor Notice"
    )
  end
end
