defmodule Grid.Admin.Vendor.Product.Price.AmountControllerTest do
  use Grid.ConnCase

  alias Grid.Amount
  @valid_attrs %{amount: "120.5", min_quantity: 5, max_quantity: 42}
  @invalid_attrs %{amount: "-1"}

  setup do
    amount
      = %{price: price = %{
            product: product = %{
              vendor: vendor
            }
          }
        }
      = Factory.create(:amount)
    {:ok, price: price, vendor: vendor, product: product, amount: amount}
  end

  test "index redirects to price", %{conn: conn, vendor: v, product: p, price: price, amount: amount} do
    conn = get conn, admin_vendor_product_price_amount_path(conn, :show, v, p, price, amount)
    assert redirected_to(conn) == admin_vendor_product_price_path(conn, :show, v, p, price)
  end

  test "shows redirects to price", %{conn: conn, vendor: v, product: p, price: price, amount: amount} do
    conn = get conn, admin_vendor_product_price_amount_path(conn, :show, v, p, price, amount)
    assert redirected_to(conn) == admin_vendor_product_price_path(conn, :show, v, p, price)
  end

  test "renders form for new resources", %{conn: conn, vendor: v, product: p, price: price} do
    conn = get conn, admin_vendor_product_price_amount_path(conn, :new, v, p, price)
    assert html_response(conn, 200) =~ "New Amount"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, vendor: v, product: p, price: price} do
    conn = post conn, admin_vendor_product_price_amount_path(conn, :create, v, p, price), amount: @valid_attrs
    assert redirected_to(conn) == admin_vendor_product_price_path(conn, :show, v, p, price)
    assert Repo.get_by(Amount, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, vendor: v, product: p, price: price} do
    conn = post conn, admin_vendor_product_price_amount_path(conn, :create, v, p, price), amount: @invalid_attrs
    assert html_response(conn, 200) =~ "New Amount"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, vendor: v, product: p, price: price} do
    assert_error_sent 404, fn ->
      get conn, admin_vendor_product_price_amount_path(conn, :show, v, p, price, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, vendor: v, product: p, price: price, amount: amount} do
    conn = get conn, admin_vendor_product_price_amount_path(conn, :edit, v, p, price, amount)
    assert html_response(conn, 200) =~ "Edit Amount"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, vendor: v, product: p, price: price, amount: amount} do
    conn = put conn, admin_vendor_product_price_amount_path(conn, :update, v, p, price, amount), amount: @valid_attrs
    assert redirected_to(conn) == admin_vendor_product_price_path(conn, :show, v, p, price)
    assert Repo.get_by(Amount, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, vendor: v, product: p, price: price, amount: amount} do
    conn = put conn, admin_vendor_product_price_amount_path(conn, :update, v, p, price, amount), amount: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Amount"
  end

  test "deletes chosen resource", %{conn: conn, vendor: v, product: p, price: price, amount: amount} do
    conn = delete conn, admin_vendor_product_price_amount_path(conn, :delete, v, p, price, amount)
    assert redirected_to(conn) == admin_vendor_product_price_path(conn, :show, v, p, price)
    refute Repo.get(Amount, amount.id)
  end

  test "rounds amount to two places", %{conn: conn, vendor: v, product: p, price: price, amount: amount} do
    put conn, admin_vendor_product_price_amount_path(conn, :update, v, p, price, amount), amount: %{@valid_attrs | amount: "3.999"}
    amount = Repo.get!(Amount, amount.id)
    assert amount.amount == 4.00
  end
end
