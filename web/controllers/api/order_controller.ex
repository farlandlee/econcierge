defmodule Grid.Api.OrderController do
  use Grid.Web, :controller

  alias Grid.{
    Cart,
    CartError,
    Coupon,
    Order,
    User,
    Vendor
  }
  alias Grid.Plugs.RequireParams

  plug RequireParams, ~w(stripe_token user cart)

  def process_cart(conn, %{"stripe_token" => stripe_token, "cart" => cart, "user" => user}) do
    coupon = validate_coupon!(conn.params["coupon"])
    customer = load_customer!(user)
    order = cart
      |> Cart.to_order_params!
      |> Order.creation_changeset(user_id: customer.id, coupon: coupon)
      |> Repo.insert!

    # After success...
    if (coupon) do
      coupon
      |> Coupon.increment_usage
      |> Repo.update_all([])
    end

    Grid.Stripe.link_customer(customer, stripe_token)

    send_for_order(order)

    conn
    |> put_status(:created)
    |> render("show.json", order: order)
  end

  defp validate_coupon!(nil), do: nil
  defp validate_coupon!(%{"id" => id, "percent_off" => percent_off, "code" => code}) do
    coupon = Repo.get_by(Coupon, id: id, percent_off: percent_off, code: code)
    if coupon && Coupon.valid?(coupon) do
      coupon
    else
      raise CartError, message: "Invalid coupon"
    end
  end

  defp load_customer!(%{"email" => email} = user_params) do
    changeset = case Repo.get_by(User, email: email) do
      nil  -> User.changeset(%User{}, user_params)
      user -> User.changeset(user, user_params)
    end

    Repo.insert_or_update!(changeset)
  end

  defp load_customer!(_) do
    raise CartError, message: "User email is required"
  end

  ############
  ## Emails ##
  ############

  # The fact that some models are already loaded on the order,
  # but not others, means that we have to reload it if we want
  # ecto to preload properly.
  def send_for_order(%{id: id}) do
    order = Order
      |> Repo.get!(id)
      |> Repo.preload([:user, [order_items: [product: [:vendor, :experience, :meeting_location]]]])

    send_request_received(order)
    Enum.each(order.order_items, &(send_vendor_notice(&1)))
  end

  def send_request_received(order) do
    html = Phoenix.View.render_to_string(Grid.EmailView, "request_received_customer.html", order: order)

    Postmark.email(
      order.user.email,
      html,
      "Your booking requests have been submitted",
      "Customer Request"
    )
  end

  def send_vendor_notice(oi) do
    html = Phoenix.View.render_to_string(Grid.EmailView, "request_received_vendor.html", order_item: oi)

    Postmark.email(
      Vendor.email(oi.product.vendor),
      html,
      "New Booking Request - #{oi.product.name}",
      "Vendor Notice"
    )
  end
end
