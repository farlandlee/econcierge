defmodule Grid.PriceControllerTest do
  use Grid.ConnCase

  alias Grid.Price
  import Grid.Factory
  @valid_attrs %{amount: "120.5", description: "some content", name: "some content", people_count: 1}
  @invalid_attrs %{amount: "poopies", people_count: -1}

  setup do
    price = create(:price)
    product = price.product
    vendor = product.vendor
    {:ok, price: price, product: product, vendor: vendor}
  end

  test "renders form for new resources", %{conn: conn, vendor: vendor, product: product} do
    conn = get conn, admin_vendor_product_price_path(conn, :new, vendor, product)
    assert html_response(conn, 200) =~ "New Price"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, vendor: vendor, product: product} do
    conn = post conn, admin_vendor_product_price_path(conn, :create, vendor, product), price: @valid_attrs
    assert redirected_to(conn) == admin_vendor_product_path(conn, :show, vendor, product)
    assert Repo.get_by(Price, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, vendor: vendor, product: product} do
    conn = post conn, admin_vendor_product_price_path(conn, :create, vendor, product), price: @invalid_attrs
    assert html_response(conn, 200) =~ "New Price"
  end

  test "renders form for editing chosen resource", %{conn: conn, vendor: vendor, product: product, price: price} do
    conn = get conn, admin_vendor_product_price_path(conn, :edit, vendor, product, price)
    assert html_response(conn, 200) =~ "Edit Price"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, vendor: vendor, product: product, price: price} do
    conn = put conn, admin_vendor_product_price_path(conn, :update, vendor, product, price), price: @valid_attrs
    assert redirected_to(conn) == admin_vendor_product_path(conn, :show, vendor, product)
    assert Repo.get_by(Price, @valid_attrs)
  end

  test "rounds price to two places", %{conn: conn, vendor: vendor, product: product, price: price} do
    put conn, admin_vendor_product_price_path(conn, :update, vendor, product, price), price: %{@valid_attrs | amount: "3.999"}
    price = Repo.get!(Price, price.id)
    assert price.amount == 4.00
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, vendor: vendor, product: product, price: price} do
    conn = put conn, admin_vendor_product_price_path(conn, :update, vendor, product, price), price: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Price"
  end

  test "deletes chosen resource", %{conn: conn, vendor: vendor, product: product, price: price} do
    conn = delete conn, admin_vendor_product_price_path(conn, :delete, vendor, product, price)
    assert redirected_to(conn) == admin_vendor_product_path(conn, :show, vendor, product)
    refute Repo.get(Price, price.id)
  end

  test "set default price", %{conn: conn, vendor: vendor, product: product, price: price} do
    conn = put conn, admin_vendor_product_price_path(conn, :set_default, vendor, product, price)
    assert redirected_to(conn) =~ admin_vendor_product_path(conn, :show, vendor, product)

    conn = conn |> recycle_with_auth |> get(admin_vendor_product_path(conn, :show, vendor, product))
    assert html_response(conn, 200) =~ "Current default"

    product = Repo.get!(Grid.Product, product.id)
    assert product.default_price_id == price.id
  end
end
