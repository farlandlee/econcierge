defmodule Grid.Admin.Vendor.Product.StartTimeControllerTest do
  use Grid.ConnCase

  alias Grid.StartTime
  import Grid.Factory

  @valid_attrs %{starts_at_time: "14:00:00"}
  @invalid_attrs %{starts_at_time: ""}

  setup do
    start_time = create(:start_time)
    product = start_time.product
    vendor = product.vendor
    {:ok, start_time: start_time, vendor: vendor, product: product}
  end

  test "creates resource and redirects when data is valid", %{conn: conn, vendor: vendor, product: product} do
    conn = post conn, admin_vendor_product_start_time_path(conn, :create, vendor, product), start_time: @valid_attrs
    assert redirected_to(conn) == admin_vendor_product_path(conn, :show, vendor, product)
    assert Repo.get_by(StartTime, @valid_attrs)
  end

  test "does not create resource and redirects when data is invalid", %{conn: conn, vendor: vendor, product: product} do
    conn = post conn, admin_vendor_product_start_time_path(conn, :create, vendor, product), start_time: @invalid_attrs
    assert redirected_to(conn) == admin_vendor_product_path(conn, :show, vendor, product)
  end

  test "deletes chosen resource", %{conn: conn, vendor: vendor, product: product, start_time: start_time} do
    conn = delete conn, admin_vendor_product_start_time_path(conn, :delete, vendor, product, start_time)
    assert redirected_to(conn) == admin_vendor_product_path(conn, :show, vendor, product)
    refute Repo.get(StartTime, start_time.id)
  end
end
