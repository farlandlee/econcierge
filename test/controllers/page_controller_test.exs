defmodule Grid.PageControllerTest do
  use Grid.ConnCase

  test "GET /" do
    conn = get conn(), "/"
    assert html_response(conn, 200) =~ "Book Your Jackson Hole Activities"
  end
end
