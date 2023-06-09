defmodule Grid.Admin.OrderControllerTest do
  use Grid.ConnCase

  import Number.Currency

  setup do
    {:ok, Factory.create_user_order_for_product}
  end

  test "lists all entries on index", %{conn: conn, order: order, user: user} do
    conn = get conn, admin_order_path(conn, :index)
    response = html_response(conn, 200)
    assert response =~ "Orders Listing"

    assert response =~ "#"
    assert response =~ "#{order.id}"
    assert response =~ "Reference Id"
    assert response =~ order.customer_token
    assert response =~ "User"
    assert response =~ user.email
    assert response =~ "# of items"
    assert response =~ "1"
    assert response =~ "# accepted"
    assert response =~ "0"
    assert response =~ "# rejected"
    assert response =~ "1"
    assert response =~ "Processed / Total amount"
    assert response =~ "$0/#{number_to_currency(order.total_amount)}"
    assert response =~ "Placed On"
    assert response =~ "#{order.inserted_at}"
  end

  test "shows chosen resource", %{conn: conn, order: order, user: user, order_item: order_item, product: product} do
    conn = get conn, admin_order_path(conn, :show, order)
    response = html_response(conn, 200)

    # Order
    assert response =~ "Reference"
    assert response =~ order.customer_token
    assert response =~ "Placed On"
    assert response =~ "#{order.inserted_at}"
    assert response =~ "Total amount"
    assert response =~ "#{number_to_currency(order.total_amount)}"

    # Customer
    assert response =~ "Customer Name"
    assert response =~ user.name
    assert response =~ "Customer Email"
    assert response =~ user.email
    assert response =~ "Customer Phone"
    assert response =~ user.phone

    # Order item
    assert response =~ "#"
    assert response =~ "#{order_item.id}"
    assert response =~ "Reference ID"
    assert response =~ "#{order_item.vendor_token}"
    assert response =~ "Vendor"
    assert response =~ product.vendor.name
    assert response =~ "Experience"
    assert response =~ product.experience.name
    assert response =~ "Product"
    assert response =~ product.name
    assert response =~ "When"
    assert response =~ "#{order_item.activity_at}"
    assert response =~ "Quantities"
    assert response =~ "Cost"
    assert response =~ "#{number_to_currency(order_item.amount)}"
    assert response =~ "Status"
    assert response =~ "#{order_item.status}"
    assert response =~ "Vendor Reply At"
    assert response =~ "#{order_item.vendor_reply_at}"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, admin_order_path(conn, :show, -1)
    end
  end

  test "finds an order item by reference id", %{conn: conn, order_item: order_item} do
    conn = get conn, admin_order_path(conn, :find_order_item, %{vendor_token: order_item.vendor_token})
    assert redirected_to(conn) == admin_order_path(conn, :show, order_item.order_id)
  end

  test "finds an order item by a legacy/longer reference id", %{conn: conn, order_item: order_item} do
    conn = get conn, admin_order_path(conn, :find_order_item, %{vendor_token: order_item.vendor_token <> "xxxxxxxxx"})
    assert redirected_to(conn) == admin_order_path(conn, :show, order_item.order_id)
  end

  test "does not find order item by reference id", %{conn: conn} do
    conn = get conn, admin_order_path(conn, :find_order_item, %{vendor_token: "xyz"})
    assert redirected_to(conn) == admin_dashboard_path(conn, :index)
  end
end
