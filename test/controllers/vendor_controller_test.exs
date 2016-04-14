defmodule Grid.VendorControllerTest do
  use Grid.ConnCase

  test "shows vendors having published products" do
    vendor = Factory.create(:vendor)
    Factory.create(:product, vendor: vendor)

    conn = get conn, vendor_path(conn, :index)
    response = html_response(conn, 200)
    assert response =~ "Our Partners"
    assert response =~ vendor.name
    assert response =~ vendor.description
  end

  test "does not show vendors w/o published products" do
    vendor = Factory.create(:vendor)
    Factory.create(:product, vendor: vendor, published: false)

    conn = get conn, vendor_path(conn, :index)
    response = html_response(conn, 200)
    refute response =~ vendor.name
  end
end
