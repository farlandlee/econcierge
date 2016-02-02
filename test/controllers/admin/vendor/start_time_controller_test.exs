defmodule Grid.Admin.Vendor.Product.StartTimeControllerTest do
  use Grid.ConnCase

  alias Grid.StartTime
  import Grid.Factory

  @valid_attrs %{starts_at_time: %Ecto.Time{hour: 1, min: 1, sec: 1}}
  @invalid_attrs %{starts_at_time: nil}

  setup do
    start_time = create_start_time()
    product = start_time.product
    {:ok,
      start_time: start_time,
      season: start_time.season,
      product: product,
      vendor: product.vendor
    }
  end

  test "Index redirects to product", %{conn: conn, vendor: vendor, product: product} do
    conn = get conn, admin_vendor_product_start_time_path(conn, :index, vendor, product)
    assert redirected_to(conn) == admin_vendor_product_path(conn, :show, vendor, product)
  end

  test "Show redirects to product", %{conn: conn, vendor: vendor, product: product, start_time: start_time} do
    conn = get conn, admin_vendor_product_start_time_path(conn, :show, vendor, product, start_time)
    assert redirected_to(conn) == admin_vendor_product_path(conn, :show, vendor, product)
  end

  test "New links to season creation if the vendor has no seasons", %{conn: conn} do
    product = create(:product)
    conn = get conn, admin_vendor_product_start_time_path(conn, :new, product.vendor, product)
    assert html_response(conn, 200) =~ admin_vendor_vendor_activity_path(conn, :index, product.vendor)
  end

  test "renders form for new resources", %{conn: conn, vendor: vendor, product: product} do
    conn = get conn, admin_vendor_product_start_time_path(conn, :new, vendor, product)
    assert html_response(conn, 200) =~ "New Start Time"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, vendor: vendor, product: product, season: season} do
    valid_attrs = @valid_attrs |> Map.put(:season_id, season.id)
    conn = post conn, admin_vendor_product_start_time_path(conn, :create, vendor, product), start_time: valid_attrs
    assert redirected_to(conn) == admin_vendor_product_path(conn, :show, vendor, product)
    assert Repo.get_by(StartTime, valid_attrs)
  end

  test "does not create resource and renders new page when data is invalid", %{conn: conn, vendor: vendor, product: product} do
    conn = post conn, admin_vendor_product_start_time_path(conn, :create, vendor, product), start_time: @invalid_attrs
    assert html_response(conn, 200) =~ "New Start Time"
  end

  test "renders form for editing chosen resource", %{conn: conn, vendor: vendor, product: product, start_time: start_time} do
    conn = get conn, admin_vendor_product_start_time_path(conn, :edit, vendor, product, start_time)
    assert html_response(conn, 200) =~ "Edit Start Time"
  end

  test "deletes chosen resource", %{conn: conn, vendor: vendor, product: product, start_time: start_time} do
    conn = delete conn, admin_vendor_product_start_time_path(conn, :delete, vendor, product, start_time)
    assert redirected_to(conn) == admin_vendor_product_path(conn, :show, vendor, product)
    refute Repo.get(StartTime, start_time.id)
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, vendor: vendor, product: product, start_time: start_time} do
    conn = put conn, admin_vendor_product_start_time_path(conn, :update, vendor, product, start_time), start_time: @valid_attrs
    assert redirected_to(conn) == admin_vendor_product_path(conn, :show, vendor, product)
    get_by_params = [starts_at_time: Ecto.Time.to_string(@valid_attrs.starts_at_time)]
    assert Repo.get_by(StartTime, get_by_params)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, vendor: vendor, product: product, start_time: start_time} do
    conn = put conn, admin_vendor_product_start_time_path(conn, :update, vendor, product, start_time), start_time: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Start Time"
  end
end
