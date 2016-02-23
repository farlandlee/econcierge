defmodule Grid.Api.OrderControllerTest do
  use Grid.ConnCase

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

    Repo.update!(Grid.Product.default_price_changeset(p, price.id))

    quantity = %{price_id: price.id, quantity: 3, cost: amount.amount}

    cart_item = %{
      client_id: "b33430",
      product_id: p.id,
      date: two_days_from_now,
      start_time_id: st.id,
      quantities: [quantity]
    }

    user = %{
      email: "test@outpostjh.com",
      name: "Jane Traveller",
      phone: "307-413-9999"
    }

    {:ok, product: p, price: price, start_time: st, user: user, cart_item: cart_item, quantity: quantity}
  end

  test "creates and renders resource when data is valid", %{conn: conn, user: user, cart_item: ci} do
    conn = post conn, api_order_path(conn, :process_cart), %{user: user, cart: [ci]}
    response = json_response(conn, 201)
    assert response["order"]["customer_token"]
  end

  test "does not create resource and renders errors on bad user", %{conn: conn} do
    conn = post conn, api_order_path(conn, :process_cart), %{user: %{}}
    response = json_response(conn, 422)
    assert ["No user in payload"] == response["errors"]

    conn = post conn, api_order_path(conn, :process_cart), %{}
    response = json_response(conn, 422)
    assert ["No user in payload"] == response["errors"]

    conn = post conn, api_order_path(conn, :process_cart), %{user: %{email: "jjjj"}}
    response = json_response(conn, 422)
    assert %{"email" => ["has invalid format"], "name" => ["can't be blank"]} == response["errors"]
  end

  test "does not create resource and renders errors with empty cart", %{conn: conn, user: user} do
    conn = post conn, api_order_path(conn, :process_cart), %{user: user, cart: []}
    response = json_response(conn, 422)
    assert ["No items in cart"] == response["errors"]

    conn = post conn, api_order_path(conn, :process_cart), %{user: user}
    response = json_response(conn, 422)
    assert ["No items in cart"] == response["errors"]
  end

  test "does not create resource and renders errors with invalid cart item", %{conn: conn, user: user, cart_item: ci} do
    ci = Map.delete(ci, :product_id)

    conn = post conn, api_order_path(conn, :process_cart), %{user: user, cart: [ci]}
    response = json_response(conn, 422)
    assert [%{"client_id" => "b33430", "message" => "Invalid cart item"}] == response["errors"]
  end

  test "does not create resource and renders errors with bad product", %{conn: conn, user: user, cart_item: ci} do
    ci = put_in(ci.product_id, 9999)

    conn = post conn, api_order_path(conn, :process_cart), %{user: user, cart: [ci]}
    response = json_response(conn, 422)
    assert [%{"client_id" => "b33430", "message" => "Could not find product"}] == response["errors"]
  end

  test "does not create resource and renders errors with bad start_time", %{conn: conn, user: user, cart_item: ci} do
    ci = put_in(ci.start_time_id, 9999)

    conn = post conn, api_order_path(conn, :process_cart), %{user: user, cart: [ci]}
    response = json_response(conn, 422)
    assert [%{"client_id" => "b33430", "message" => "Could not find start_time"}] == response["errors"]
  end

  test "does not create resource and renders errors, no prices", %{conn: conn, user: user, cart_item: ci} do
    Repo.delete_all(Grid.Price)

    conn = post conn, api_order_path(conn, :process_cart), %{user: user, cart: [ci]}
    response = json_response(conn, 422)
    assert [%{"client_id" => "b33430", "message" => "No prices found for product"}] == response["errors"]
  end

  test "does not create resource and renders errors, no price id", %{conn: conn, user: user, cart_item: ci, quantity: q} do
    q = Map.delete(q, :price_id)
    ci = put_in(ci.quantities, [q])

    conn = post conn, api_order_path(conn, :process_cart), %{user: user, cart: [ci]}
    response = json_response(conn, 422)
    assert [%{"client_id" => "b33430", "message" => "No price id included in quantity"}] == response["errors"]
  end

  test "does not create resource and renders errors, price not found", %{conn: conn, user: user, cart_item: ci, quantity: q} do
    q = put_in(q.price_id, 9999)
    ci = put_in(ci.quantities, [q])

    conn = post conn, api_order_path(conn, :process_cart), %{user: user, cart: [ci]}
    response = json_response(conn, 422)
    assert [%{"client_id" => "b33430", "message" => "Price not found"}] == response["errors"]
  end

  test "does not create resource and renders errors, quantity not included", %{conn: conn, user: user, cart_item: ci, quantity: q} do
    q = Map.delete(q, :quantity)
    ci = put_in(ci.quantities, [q])

    conn = post conn, api_order_path(conn, :process_cart), %{user: user, cart: [ci]}
    response = json_response(conn, 422)
    assert [%{"client_id" => "b33430", "message" => "Quantity not included"}] == response["errors"]
  end

  test "does not create resource and renders errors, amount not found", %{conn: conn, user: user, cart_item: ci} do
    Repo.delete_all(Grid.Amount)

    conn = post conn, api_order_path(conn, :process_cart), %{user: user, cart: [ci]}
    response = json_response(conn, 422)
    assert [%{"client_id" => "b33430", "message" => "Amount not found"}] == response["errors"]
  end

  test "does not create resource and renders errors, cost not included", %{conn: conn, user: user, cart_item: ci, quantity: q} do
    q = Map.delete(q, :cost)
    ci = put_in(ci.quantities, [q])

    conn = post conn, api_order_path(conn, :process_cart), %{user: user, cart: [ci]}
    response = json_response(conn, 422)
    assert [%{"client_id" => "b33430", "message" => "Cost not included"}] == response["errors"]
  end

  test "does not create resource and renders errors with invalid cost", %{conn: conn, user: user, cart_item: ci, quantity: q} do
    q = put_in(q.cost, 10)
    ci = put_in(ci.quantities, [q])

    conn = post conn, api_order_path(conn, :process_cart), %{user: user, cart: [ci]}
    response = json_response(conn, 422)
    assert [%{"client_id" => "b33430", "message" => "Quantity cost is invalid for price: #{q.price_id}"}] == response["errors"]
  end
end
