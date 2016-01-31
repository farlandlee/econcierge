defmodule Grid.PriceControllerTest do
  use Grid.ConnCase

  alias Grid.Price
  import Grid.Factory

  @valid_attrs %{description: "some content", name: "some content", people_count: 1}
  @invalid_attrs %{amount: "bad amount", people_count: -1}

  setup do
    amount = %{price: price} = create(:amount)
    product = price.product
    vendor = product.vendor
    {:ok, price: price, product: product, vendor: vendor, amount: amount}
  end

  test "Index redirects to product", %{conn: conn, vendor: vendor, product: product} do
    conn = get conn, admin_vendor_product_price_path(conn, :index, vendor, product)
    assert redirected_to(conn) == admin_vendor_product_path(conn, :show, vendor, product)
  end

  test "Show renders price", %{conn: conn, vendor: vendor, product: product, price: price} do
    conn = get conn, admin_vendor_product_price_path(conn, :show, vendor, product, price)
    response = html_response(conn, 200)
    assert response =~ price.name
    assert response =~ price.description
    assert response =~ "People Count"
    assert response =~ "#{price.people_count}"
  end

  test "show lists amount all pretty and shit", %{conn: conn, vendor: vendor, product: product, price: price, amount: amount} do
    conn = get conn, admin_vendor_product_price_path(conn, :show, vendor, product, price)
    response = html_response(conn, 200)
    assert response =~ "Amount"
    assert response =~ "#{amount.amount}"
    assert response =~ "&infin;"
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
