defmodule Grid.Admin.OrderControllerTest do
  use Grid.ConnCase

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, admin_order_path(conn, :index)
    assert html_response(conn, 200) =~ "Orders Listing"
  end

  # test "shows chosen resource", %{conn: conn} do
  #   user = conn.assigns.current_user
  #   order = Repo.insert! %Order{}
  #   conn = get conn, admin_order_path(conn, :show, order)
  #   assert html_response(conn, 200) =~ ""
  # end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, admin_order_path(conn, :show, -1)
    end
  end
end
