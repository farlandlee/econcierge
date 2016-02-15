defmodule Grid.Api.VendorControllerTest do
  use Grid.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup do
    {:ok, vendor: Factory.create(:vendor)}
  end

  test "index lists vendors with products", %{conn: conn, vendor: vendor} do
    Factory.create(:product, vendor: vendor)
    conn = get conn, api_vendor_path(conn, :index)
    response = json_response(conn, 200)
    vendors = response["vendors"]

    assert Enum.count(vendors) == 1
    assert hd(vendors)["id"] == vendor.id
  end

  test "index doesn't rendor vendors without products", %{conn: conn} do
    conn = get conn, api_vendor_path(conn, :index)
    response = json_response(conn, 200)
    vendors = response["vendors"]

    assert Enum.count(vendors) == 0
  end

  test "shows chosen resource", %{conn: conn, vendor: vendor} do
    conn = get conn, api_vendor_path(conn, :show, vendor)
    response = json_response(conn, 200)
    resp_vendor = response["vendor"]

    assert resp_vendor["id"] == vendor.id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, api_vendor_path(conn, :show, -1)
    end
  end
end
