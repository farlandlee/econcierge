defmodule Grid.Admin.ProductControllerTest do
  use Grid.ConnCase

  import Ecto.Query
  import Grid.Factory

  alias Grid.Product

  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{name: ""}

  setup do
    c = Factory.create(:category)
    a = Factory.create(:activity)
    v = Factory.create(:vendor)
    Factory.create(:vendor_activity, vendor: v, activity: a)

    e = Factory.create(:experience, activity: a)
    p = Factory.create(:product, vendor: v, experience: e)

    Factory.create(:experience_category, experience: e, category: c)

    {:ok,
      product: p,
      vendor: v,
      activity: a,
      category: c,
      experience: e
    }
  end

  test "Show lists prices", %{conn: conn} do
    price = create(:price)
    product = price.product
    vendor = product.vendor
    conn = get conn, admin_vendor_product_path(conn, :show, vendor, product)
    response = html_response(conn, 200)
    assert response =~ "Prices"
    assert response =~ "Add Price"
    assert response =~ "#{product.name}"
    assert response =~ "Amount"
    assert response =~ "$#{price.amount}"
    assert response =~ "Name"
    assert response =~ "#{price.name}"
    assert response =~ "Description"
    assert response =~ "#{price.description}"
  end

  test "Show lists start times", %{conn: conn} do
    start_time = create(:start_time)
    product = start_time.product
    vendor = product.vendor

    conn = get conn, admin_vendor_product_path(conn, :show, vendor, product)
    response = html_response(conn, 200)
    assert response =~ "Start Times"
    assert response =~ "Add Start Time"
    assert response =~ Ecto.Time.to_string(start_time.starts_at_time)
  end

  test "Show page doesn't show other products' start times", %{conn: conn} do
    start_time = create(:start_time)
    product = start_time.product
    vendor = product.vendor

    conn = get conn, admin_vendor_product_path(conn, :show, vendor, product)
    other_vendors_products_time = create(:start_time)
    response = html_response(conn, 200)
    refute response =~ other_vendors_products_time.starts_at_time |> Ecto.Time.to_string
  end

  test "Only shows start times for this product", %{conn: conn, vendor: v} do
    [s1, s2] = create_pair(:start_time)
    # set products to same vendor
    Grid.Product
    |> where([p], p.id in ^([s1.product.id, s2.product.id]))
    |> update(set: [vendor_id: ^v.id])
    |> Repo.update_all([])

    conn = get conn, admin_vendor_product_path(conn, :show, v, s1.product)

    response = html_response(conn, 200)
    assert response =~ s1.starts_at_time |> Ecto.Time.to_string
    refute response =~ s2.starts_at_time |> Ecto.Time.to_string
  end

  test "renders form for new resources", %{conn: conn, vendor: v, experience: e} do
    conn = get conn, admin_vendor_product_path(conn, :new, v.id)
    response = html_response(conn, 200)
    assert response =~ "New Product"
    assert response =~ "Experience"
    assert response =~ "#{e.name}"
  end

  # TODO: Start HERE!!!!!!
  test "filters experiences by vendor activities", %{conn: conn, vendor: v, product: p} do
    some_other_experience = Factory.create(:experience)

    conn = get conn, admin_vendor_product_path(conn, :new, v)
    response = html_response(conn, 200)
    refute response =~ some_other_experience.name
    assert response =~ p.experience.name

    conn = conn |> recycle |> get(admin_vendor_product_path(conn, :edit, v, p))
    response = html_response(conn, 200)
    refute response =~ some_other_experience.name
    assert response =~ p.experience.name
  end

  test "creates resource and redirects when data is valid", %{conn: conn, vendor: v} do
    e = Factory.create(:experience)
    valid_attrs = @valid_attrs |> Map.put(:experience, e.id)
    conn = post conn, admin_vendor_product_path(conn, :create, v), product: valid_attrs

    product = Repo.get_by(Product, @valid_attrs)

    assert product
    assert redirected_to(conn) == admin_vendor_product_path(conn, :show, v, product)
  end

  test "shows chosen resource", %{conn: conn, vendor: v, product: p} do
    conn = get conn, admin_vendor_product_path(conn, :show, v, p)
    response = html_response(conn, 200)
    assert response =~ "#{p.name}"
    assert response =~ "#{p.description}"
    assert response =~ "Experience"
    assert response =~ "#{p.experience.name}"
    # has link to edit
    assert response =~ "Edit"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, vendor: v} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, admin_vendor_product_path(conn, :show, v, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, vendor: v, product: p} do
    conn = get conn, admin_vendor_product_path(conn, :edit, v, p)
    response = html_response(conn, 200)
    assert response =~ "Edit Product"
    assert response =~ "Name"
    assert response =~ p.name
    assert response =~ "Description"
    assert response =~ p.description
    assert response =~ "Experience"
    assert response =~ p.experience.name
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, vendor: v, product: p, activity: a} do
    e = Factory.create(:experience, activity: a)

    update_params = %{
      name: "fun adventure!",
      description: "wahoo",
      experience_id: e.id
    }

    conn = put conn, admin_vendor_product_path(conn, :update, v, p), product: update_params
    assert redirected_to(conn) == admin_vendor_product_path(conn, :show, v, p)
    assert Repo.get_by(Product, update_params |> Map.take([:name, :description]))
  end


  test "deletes chosen resource", %{conn: conn, vendor: v, product: p} do
    conn = delete conn, admin_vendor_product_path(conn, :delete, v, p)
    assert redirected_to(conn) == admin_vendor_path(conn, :show, v)
    refute Repo.get(Product, p.id)
  end
end
