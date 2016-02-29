defmodule Grid.OrderStatusControllerTest do
  use Grid.ConnCase

  alias Grid.{
    Repo,
    OrderItem
  }

  setup do
    user = Factory.create(:user)
    product = Factory.create(:product)
    order = Factory.create_user_order_for_product(user, product)
    item = order.order_items |> hd

    {:ok, order: order, order_item: item}
  end

  test "Show vendor order item status without status 404s", %{conn: conn, order_item: oi} do
    assert_error_sent 404, fn ->
      get(conn, order_status_path(conn, :vendor_status, oi.vendor_token))
    end
  end

  test "Accept order item", %{conn: conn, order_item: oi} do
    conn = get(conn, order_status_path(conn, :accept, oi.vendor_token))
    assert redirected_to(conn) == order_status_path(conn, :vendor_status, oi.vendor_token)
    assert get_flash(conn, :info) =~ "You have successfully accepted this request"
  end

  test "Accept order item that already has status", %{conn: conn, order_item: oi} do
    OrderItem.status_changeset(oi, :accept) |> Repo.update!

    conn = get(conn, order_status_path(conn, :accept, oi.vendor_token))
    assert redirected_to(conn) == order_status_path(conn, :vendor_status, oi.vendor_token)
    assert get_flash(conn, :error) =~ "Request has already been accepted"
  end

  test "Reject order item", %{conn: conn, order_item: oi} do
    conn = get(conn, order_status_path(conn, :reject, oi.vendor_token))
    assert redirected_to(conn) == order_status_path(conn, :vendor_status, oi.vendor_token)
    assert get_flash(conn, :info) =~ "You have successfully rejected this request"
  end

  test "Reject order item that already has status", %{conn: conn, order_item: oi} do
    OrderItem.status_changeset(oi, :accept) |> Repo.update!

    conn = get(conn, order_status_path(conn, :reject, oi.vendor_token))
    assert redirected_to(conn) == order_status_path(conn, :vendor_status, oi.vendor_token)
    assert get_flash(conn, :error) =~ "Request has already been accepted"
  end
end
