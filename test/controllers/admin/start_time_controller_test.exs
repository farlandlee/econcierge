defmodule Grid.Admin.Vendor.Product.StartTimeControllerTest do
  use Grid.ConnCase

  alias Grid.StartTime
  import Grid.Factory
  import Ecto.Query
  @valid_attrs %{starts_at_time: "14:00:00"}
  @invalid_attrs %{starts_at_time: ""}

  setup do
    conn = conn()
    start_time = create(:start_time)
    product = start_time.product
    vendor = product.vendor
    {:ok, conn: conn, start_time: start_time, vendor: vendor, product: product}
  end

  test "lists all entries on index", %{conn: conn, vendor: vendor, product: product, start_time: start_time} do
    conn = get conn, admin_vendor_product_start_time_path(conn, :index, vendor, product)
    response = html_response(conn, 200)
    assert response =~ "#{product.name} Start Times"
    assert response =~ Ecto.Time.to_string(start_time.starts_at_time)
  end

  test "Index doesn't show other products' start times", %{conn: conn, vendor: vendor, product: product, start_time: start_time} do
    conn = get conn, admin_vendor_product_start_time_path(conn, :index, vendor, product)
    other_vendors_products_time = create(:start_time)
    assert response = html_response(conn, 200)
    refute response =~ other_vendors_products_time.starts_at_time |> Ecto.Time.to_string
  end

  test "Index only shows start times for that product", %{conn: conn, vendor: v} do
    [s1, s2] = create_pair(:start_time)
    # set products to same vendor
    Grid.Product
    |> where([p], p.id in ^([s1.product.id, s2.product.id]))
    |> update(set: [vendor_id: ^v.id])
    |> Repo.update_all([])

    conn = get conn, admin_vendor_product_start_time_path(conn, :index, v, s1.product)

    assert response = html_response(conn, 200)
    assert response =~ s1.starts_at_time |> Ecto.Time.to_string
    refute response =~ s2.starts_at_time |> Ecto.Time.to_string
  end

  test "creates resource and redirects when data is valid", %{conn: conn, vendor: vendor, product: product} do
    conn = post conn, admin_vendor_product_start_time_path(conn, :create, vendor, product), start_time: @valid_attrs
    assert redirected_to(conn) == admin_vendor_product_start_time_path(conn, :index, vendor, product)
    assert Repo.get_by(StartTime, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, vendor: vendor, product: product} do
    conn = post conn, admin_vendor_product_start_time_path(conn, :create, vendor, product), start_time: @invalid_attrs
    assert html_response(conn, 200) =~ "#{product.name} Start Times"
  end

  test "deletes chosen resource", %{conn: conn, vendor: vendor, product: product, start_time: start_time} do
    conn = delete conn, admin_vendor_product_start_time_path(conn, :delete, vendor, product, start_time)
    assert redirected_to(conn) == admin_vendor_product_start_time_path(conn, :index, vendor, product)
    refute Repo.get(StartTime, start_time.id)
  end
end
