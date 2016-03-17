defmodule Grid.Api.OrderControllerTest do
  use Grid.ConnCase

  alias Grid.CartError

  alias Grid.Order

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup do
    today = Calendar.Date.from_erl!(:erlang.date())

    two_days_from_now = today
      |> Calendar.Date.advance!(2)
      |> Ecto.Date.cast!
      |> Ecto.Date.to_string

    season_start = today
      |> Calendar.Date.advance!(-4)
      |> Ecto.Date.cast!

    season_end = today
      |> Calendar.Date.advance!(60)
      |> Ecto.Date.cast!

    st = %{product: p} = Factory.create_start_time(
      season: Factory.create(:season,
        start_date: season_start,
        end_date: season_end
      )
    )

    price = Factory.create(:price, product: p)
    amount = Factory.create(:amount, price: price)

    price2 = Factory.create(:price, product: p)

    Repo.update!(Grid.Product.default_price_changeset(p, price.id))

    quantity = %{id: price.id, quantity: 3, cost: amount.amount * 3}
    quantity2 = %{id: price2.id, quantity: 0, cost: 0}

    cart_item = %{
      product: p.id,
      date: two_days_from_now,
      startTime: %{ id: st.id },
      quantities: [quantity, quantity2]
    }

    user = %{
      email: "test@outpostjh.com",
      name: "Jane Traveller",
      phone: "307-413-9999"
    }

    valid_params = %{
      user: user, cart: [cart_item], stripe_token: "12345", coupon: nil
    }

    {:ok,
      product: p, price: price, startTime: st, user: user,
      cart_item: cart_item, quantity: quantity,
      valid_params: valid_params
    }
  end

  defp create_coupon_param(properties \\ []) do
    Factory.create(:coupon, properties) |> Map.take([:id, :code, :percent_off])
  end

  test "creates and renders resource when data is valid", %{conn: conn, valid_params: valid_params} do
    conn = post conn, api_order_path(conn, :process_cart), valid_params
    response = json_response(conn, 201)
    assert response["order"]["customer_token"]
  end

  test "increments coupon usage count", %{conn: conn, valid_params: valid_params} do
    coupon = create_coupon_param()
    %{usage_count: original_usage_count} = Repo.get!(Grid.Coupon, coupon.id)
    post conn, api_order_path(conn, :process_cart), %{valid_params | coupon: coupon}
    coupon = Repo.get(Grid.Coupon, coupon.id)
    assert coupon
    assert coupon.usage_count == original_usage_count + 1
  end

  test "errors on invalid coupon", %{conn: conn, valid_params: valid_params} do
    coupon = create_coupon_param(max_usage_count: 5, usage_count: 5)
    assert_raise CartError, "Invalid coupon", fn ->
      post conn, api_order_path(conn, :process_cart), %{valid_params | coupon: coupon}
    end
  end

  test "applies coupon correctly", %{conn: conn, valid_params: valid_params} do
    coupon = create_coupon_param()
    conn = post conn, api_order_path(conn, :process_cart), %{valid_params | coupon: coupon}
    assert json_response(conn, 201)

    order = Repo.get_by(Order, coupon_id: coupon.id)
    assert order
    assert order.coupon
    assert order.coupon["percent_off"] == coupon.percent_off
    assert order.coupon["id"] == coupon.id
  end

  test "does not create resource and renders errors on bad user", %{conn: conn, valid_params: valid_params} do
    assert_raise CartError, "User email is required", fn ->
      post conn, api_order_path(conn, :process_cart), valid_params |> Map.put(:user, %{})
    end

    assert_raise Phoenix.MissingParamError, ~r/^expected key "user".+/, fn ->
      post conn, api_order_path(conn, :process_cart), valid_params |> Map.delete(:user)
    end

    assert_raise Ecto.InvalidChangesetError, fn ->
      post conn, api_order_path(conn, :process_cart), valid_params |> Map.put(:user, %{email: "bad email"})
    end
  end

  test "does not create resource and renders errors with empty cart", %{conn: conn, valid_params: valid_params} do
    assert_raise CartError, "No items in cart", fn ->
      post conn, api_order_path(conn, :process_cart), valid_params |> Map.put(:cart, [])
    end

    assert_raise Phoenix.MissingParamError, ~r/^expected key "cart".+/, fn ->
      post conn, api_order_path(conn, :process_cart), valid_params |> Map.delete(:cart)
    end
  end

  test "does not create resource and renders errors with invalid cart item", %{conn: conn, cart_item: ci, valid_params: valid_params} do
    ci = Map.delete(ci, :product)

    assert_raise CartError, "No product id", fn ->
      post conn, api_order_path(conn, :process_cart), valid_params |> Map.put(:cart, [ci])
    end
  end

  test "does not create resource and renders errors with bad product", %{conn: conn, valid_params: valid_params, cart_item: ci} do
    ci = put_in(ci.product, 9999)

    assert_raise CartError, "Could not find product", fn ->
      post conn, api_order_path(conn, :process_cart), valid_params |> Map.put(:cart, [ci])
    end
  end

  test "does not create resource and renders errors with bad start_time", %{conn: conn, valid_params: valid_params, cart_item: ci} do
    ci = put_in(ci.startTime.id, 9999)

    assert_raise CartError, "Could not find start_time", fn ->
      post conn, api_order_path(conn, :process_cart), valid_params |> Map.put(:cart, [ci])
    end
  end

  test "does not create resource and renders errors, no prices", %{conn: conn, valid_params: valid_params} do
    Repo.delete_all(Grid.Price)

    assert_raise CartError, "No prices found for product", fn ->
      post conn, api_order_path(conn, :process_cart), valid_params
    end
  end

  test "does not create resource and renders errors, no price id", %{conn: conn, cart_item: ci, quantity: q, valid_params: valid_params} do
    q = Map.delete(q, :id)
    ci = put_in(ci.quantities, [q])

    assert_raise CartError, "No price id included in quantity", fn ->
      post conn, api_order_path(conn, :process_cart), valid_params |> Map.put(:cart, [ci])
    end
  end

  test "does not create resource and renders errors, price not found", %{conn: conn, quantity: q, cart_item: ci, valid_params: valid_params} do
    q = put_in(q.id, 9999)
    ci = put_in(ci.quantities, [q])

    assert_raise CartError, "Price not found", fn ->
      post conn, api_order_path(conn, :process_cart), valid_params |> Map.put(:cart, [ci])
    end
  end

  test "does not create resource and renders errors, quantity not included", %{conn: conn, cart_item: ci, quantity: q, valid_params: valid_params} do
    q = Map.delete(q, :quantity)
    ci = put_in(ci.quantities, [q])

    assert_raise CartError, "Quantity not included", fn ->
      post conn, api_order_path(conn, :process_cart), valid_params |> Map.put(:cart, [ci])
    end
  end

  test "does not create resource and renders errors, amount not found", %{conn: conn, valid_params: valid_params} do
    Repo.delete_all(Grid.Amount)

    assert_raise CartError, "Amount not found", fn ->
      post conn, api_order_path(conn, :process_cart), valid_params
    end
  end

  test "does not create resource and renders errors, cost not included", %{conn: conn, cart_item: ci, quantity: q, valid_params: valid_params} do
    q = Map.delete(q, :cost)
    ci = put_in(ci.quantities, [q])

    assert_raise CartError, "Cost not included", fn ->
      post conn, api_order_path(conn, :process_cart), valid_params |> Map.put(:cart, [ci])
    end
  end

  test "does not create resource and renders errors with invalid cost", %{conn: conn, user: user, cart_item: ci, quantity: q} do
    q = put_in(q.cost, 10)
    ci = put_in(ci.quantities, [q])

    assert_raise CartError, "Quantity cost is invalid for price: #{q.id}", fn ->
      post conn, api_order_path(conn, :process_cart), %{user: user, cart: [ci], stripe_token: "t"}
    end
  end
end
