defmodule Grid.PriceControllerTest do
  use Grid.ConnCase

  alias Grid.Price
  import Grid.Factory
  @valid_attrs %{amount: "120.5", description: "some content", name: "some content"}
  @invalid_attrs %{amount: "poopies"}

  setup do
    price = create(:price)
    {:ok, price: price, product: price.product, vendor: price.product.vendor}
  end

  test "lists all entries on index", %{conn: conn, vendor: vendor, product: product, price: price} do
    conn = get conn, admin_vendor_product_price_path(conn, :index, vendor, product)
    response = html_response(conn, 200)
    assert response =~ "Prices for #{product.name}"
    assert response =~ "Amount"
    assert response =~ "$#{price.amount}"
    assert response =~ "Name"
    assert response =~ "#{price.name}"
    assert response =~ "Description"
    assert response =~ "#{price.description}"
  end

  test "renders form for new resources", %{conn: conn, vendor: vendor, product: product} do
    conn = get conn, admin_vendor_product_price_path(conn, :new, vendor, product)
    assert html_response(conn, 200) =~ "New Price"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, vendor: vendor, product: product} do
    conn = post conn, admin_vendor_product_price_path(conn, :create, vendor, product), price: @valid_attrs
    assert redirected_to(conn) == admin_vendor_product_price_path(conn, :index, vendor, product)
    assert Repo.get_by(Price, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, vendor: vendor, product: product} do
    conn = post conn, admin_vendor_product_price_path(conn, :create, vendor, product), price: @invalid_attrs
    assert html_response(conn, 200) =~ "New Price"
  end

  test "shows chosen resource", %{conn: conn, vendor: vendor, product: product, price: price} do
    conn = get conn, admin_vendor_product_price_path(conn, :show, vendor, product, price)
    assert html_response(conn, 200) =~ "Show Price"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, vendor: vendor, product: product} do
    assert_error_sent 404, fn ->
      get conn, admin_vendor_product_price_path(conn, :show, vendor, product, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, vendor: vendor, product: product, price: price} do
    conn = get conn, admin_vendor_product_price_path(conn, :edit, vendor, product, price)
    assert html_response(conn, 200) =~ "Edit Price"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, vendor: vendor, product: product, price: price} do
    conn = put conn, admin_vendor_product_price_path(conn, :update, vendor, product, price), price: @valid_attrs
    assert redirected_to(conn) == admin_vendor_product_price_path(conn, :show, vendor, product, price)
    assert Repo.get_by(Price, @valid_attrs)
  end

  test "rounds price to two places", %{conn: conn, vendor: vendor, product: product, price: price} do
    conn = put conn, admin_vendor_product_price_path(conn, :update, vendor, product, price), price: %{@valid_attrs | amount: "3.999"}
    price = Repo.get!(Price, price.id)
    assert price.amount == 4.00
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, vendor: vendor, product: product, price: price} do
    conn = put conn, admin_vendor_product_price_path(conn, :update, vendor, product, price), price: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Price"
  end

  test "deletes chosen resource", %{conn: conn, vendor: vendor, product: product, price: price} do
    conn = delete conn, admin_vendor_product_price_path(conn, :delete, vendor, product, price)
    assert redirected_to(conn) == admin_vendor_product_price_path(conn, :index, vendor, product)
    refute Repo.get(Price, price.id)
  end

  test "set default price", %{conn: conn, vendor: vendor, product: product, price: price} do
    conn = put conn, admin_vendor_product_price_path(conn, :set_default, vendor, product, price)
    assert redirected_to(conn) =~ admin_vendor_product_price_path(conn, :index, vendor, product)

    conn = recycle(conn)
    conn = get conn, admin_vendor_product_price_path(conn, :index, vendor, product)
    assert html_response(conn, 200) =~ "Current default"

    product = Repo.get!(Grid.Product, product.id)
    assert product.default_price_id == price.id
  end
end
