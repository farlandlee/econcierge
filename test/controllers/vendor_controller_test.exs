defmodule Grid.VendorControllerTest do
  use Grid.ConnCase

  test "GET /" do
    vendor = Factory.create(:vendor)

    conn = get conn, vendor_path(conn, :index)
    response = html_response(conn, 200)
    assert response =~ "Our Partners"
    assert response =~ vendor.name
    assert response =~ vendor.description
  end
end
