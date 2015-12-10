defmodule Grid.Admin.DashboardControllerTest do
  use Grid.ConnCase

  test "GET /admin" do
    conn = get conn(), admin_dashboard_path(conn, :index)
    assert html_response(conn, 200)
  end
end
