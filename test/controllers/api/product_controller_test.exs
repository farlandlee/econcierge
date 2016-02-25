defmodule Grid.Api.ProductControllerTest do
  use Grid.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup do
    st = %{product: p, season: s} = Factory.create_start_time(
      season: Factory.create(:season,
        start_date: %Ecto.Date{year: 2016, month: 6, day: 1},
        end_date: %Ecto.Date{year: 2016, month: 6, day: 30}
      )
    )

    price = Factory.create(:price, product: p)
    Factory.create(:amount, price: price)

    p = Repo.update!(Grid.Product.default_price_changeset(p, price.id))

    {:ok, product: p, start_time: st, season: s}
  end

  test "index lists all published products", %{conn: conn, product: product} do
    published_fails_check = Factory.create(:product)
    unpublished_product = Factory.create(:product, published: false)

    conn = get conn, api_product_path(conn, :index)
    response = json_response(conn, 200)
    products = response["products"]
    assert products
    assert Enum.count(products) == 1

    resp_ids = Enum.map(products, &(&1["id"]))

    assert product.id in resp_ids
    refute published_fails_check.id in resp_ids
    refute unpublished_product.id in resp_ids
  end

  test "index filters by experience", %{conn: conn, product: product} do
    conn = get conn, api_product_path(conn, :index, experience_id: product.experience_id)
    response = json_response(conn, 200)
    products = response["products"]
    assert products
    assert Enum.count(products) == 1

    assert product.id == hd(products)["id"]

    conn = get conn, api_product_path(conn, :index, experience_id: -1)
    response = json_response(conn, 200)
    products = response["products"]
    assert products
    assert Enum.count(products) == 0
  end

  test "index filters by date", %{conn: conn, product: product} do
    conn = get conn, api_product_path(conn, :index, date: "2016-06-01")
    response = json_response(conn, 200)
    products = response["products"]
    assert products
    assert Enum.count(products) == 1

    [resp_prod] = products
    assert resp_prod["id"] == product.id

    conn = get conn, api_product_path(conn, :index, date: "2017-01-01")
    response = json_response(conn, 200)
    products = response["products"]
    assert products
    assert Enum.count(products) == 0
  end

  test "shows product", %{conn: conn, product: product} do
    conn = get conn, api_product_path(conn, :show, product)
    response = json_response(conn, 200)
    resp_prod = response["product"]

    assert resp_prod["id"] == product.id
  end

  test "show 404s when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, api_product_path(conn, :show, -1)
    end
  end

  test "show 404s unpublished product ids", %{conn: conn} do
    unpublished_id = Factory.create(:product, published: false).id
    assert_error_sent 404, fn ->
      get conn, api_product_path(conn, :show, unpublished_id)
    end
  end
end
