defmodule Grid.Admin.DashboardControllerTest do
  use Grid.ConnCase

  @tag :no_auth
  test "Requires authentication", %{conn: conn} do
    conn = get(conn, admin_dashboard_path(conn, :index))
    assert html_response(conn, 302)
  end

  test "GET /admin", %{conn: conn} do
    conn = get conn, admin_dashboard_path(conn, :index)
    assert html_response(conn, 200)
  end
end
