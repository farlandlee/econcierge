defmodule Grid.Admin.UserControllerTest do
  use Grid.ConnCase

  test "lists all entries on index", %{conn: conn} do
    user = conn.assigns.current_user
    conn = get conn, admin_user_path(conn, :index)
    response = html_response(conn, 200)
    assert response =~ "Users Listing"
    assert response =~ "Name"
    assert response =~ "Email"
    assert response =~ "#{user.name}"
    assert response =~ "#{user.email}"
  end

end
