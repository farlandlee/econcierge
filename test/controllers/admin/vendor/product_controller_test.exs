defmodule Grid.Admin.ProductControllerTest do
  use Grid.ConnCase

  import Ecto.Query
  import Grid.Factory

  alias Grid.Product
  alias Grid.StartTime
  alias Grid.Price

  @valid_attrs %{
    name: "product name", duration: 100, description: "A sweet product", pickup: true
  }

  @invalid_attrs %{name: "", duration: -1}

  setup do
    %{vendor: v, activity: a}
      = Factory.create(:vendor_activity)
    c = Factory.create(:category)

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

  test "Index redirects to vendor", %{conn: conn, vendor: vendor} do
    conn = get conn, admin_vendor_product_path(conn, :index, vendor)
    assert redirected_to(conn) == admin_vendor_path(conn, :show, vendor, tab: "products")
  end

  test "Show lists prices", %{conn: conn} do
    amount = %{price: price} = create(:amount)
    product = price.product
    vendor = product.vendor
    conn = get conn, admin_vendor_product_path(conn, :show, vendor, product)
    response = html_response(conn, 200)
    assert response =~ "Prices"
    assert response =~ "Add Price"
    assert response =~ "#{product.name}"
    assert response =~ "Amount"
    assert response =~ "$#{amount.amount}"
    assert response =~ "Name"
    assert response =~ "#{price.name}"
    assert response =~ "Description"
    assert response =~ "#{price.description}"
  end

  test "Show lists start times", %{conn: conn} do
    start_time = create_start_time
    product = start_time.product
    vendor = product.vendor

    conn = get conn, admin_vendor_product_path(conn, :show, vendor, product)
    response = html_response(conn, 200)
    assert response =~ "Start Times"
    assert response =~ "Add Start Time"
    assert response =~ Ecto.Time.to_string(start_time.starts_at_time)
  end

  test "Show page doesn't show other products' start times", %{conn: conn} do
    start_time = create_start_time
    product = start_time.product
    vendor = product.vendor

    conn = get conn, admin_vendor_product_path(conn, :show, vendor, product)
    other_vendors_products_time = create_start_time
    response = html_response(conn, 200)
    refute response =~ other_vendors_products_time.starts_at_time |> Ecto.Time.to_string
  end

  test "Only shows start times for this product", %{conn: conn, vendor: v} do
    [s1, s2] = [create_start_time, create_start_time]
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

  test "filters experiences by vendor activities", %{conn: conn, vendor: v, product: p} do
    some_other_experience = Factory.create(:experience)

    conn = get conn, admin_vendor_product_path(conn, :new, v)
    response = html_response(conn, 200)
    refute response =~ some_other_experience.name
    assert response =~ p.experience.name

    conn = conn |> recycle_with_auth |> get(admin_vendor_product_path(conn, :edit, v, p))
    response = html_response(conn, 200)
    refute response =~ some_other_experience.name
    assert response =~ p.experience.name
  end

  test "creates resource and redirects when data is valid", %{conn: conn, vendor: v} do
    e = Factory.create(:experience)
    valid_attrs = @valid_attrs |> Map.put(:experience_id, e.id)
    conn = post conn, admin_vendor_product_path(conn, :create, v), product: valid_attrs

    product = Repo.get_by(Product, @valid_attrs)

    assert product
    assert redirected_to(conn) == admin_vendor_product_path(conn, :show, v, product)
  end

  test "creates parses duration_hours duration_minutes into duration", %{conn: conn, vendor: v} do
    e = Factory.create(:experience)

    valid_attrs = @valid_attrs
      |> Map.put(:experience_id, e.id)
      |> Map.delete(:duration)
      |> Map.put(:duration_hours, "2")
      |> Map.put(:duration_minutes, "13")

    post conn, admin_vendor_product_path(conn, :create, v), product: valid_attrs

    product = Repo.get_by(Product, @valid_attrs |> Map.delete(:duration))

    assert product
    assert product.duration == 2 * 60 + 13
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
    assert redirected_to(conn) == admin_vendor_path(conn, :show, v, tab: "products")
    refute Repo.get(Product, p.id)
  end

  test "deletes product with start time and price", %{conn: conn, vendor: v, product: p} do
    start_time = Factory.create_start_time(product: p)
    price = Factory.create(:price, product: p)
    conn = delete conn, admin_vendor_product_path(conn, :delete, v, p)
    assert redirected_to(conn) == admin_vendor_path(conn, :show, v, tab: "products")
    refute Repo.get(Product, p.id)
    refute Repo.get(StartTime, start_time.id)
    refute Repo.get(Price, price.id)
  end

  test "clone", %{conn: conn, product: p, vendor: v} do
    start_time = Factory.create_start_time(product: p)
    price = Factory.build(:price, product_id: p.id) |> Repo.insert!
    amount = Factory.build(:amount, max_quantity: 10) |> Map.put(:price_id, price.id) |> Repo.insert!
    default_price = Factory.build(:price, product_id: p.id) |> Repo.insert!
    p = p |> Ecto.Changeset.change(default_price_id: default_price.id) |> Repo.update!

    conn = get conn, admin_vendor_product_path(conn, :clone, v, p)

    twins = Product
      |> where(
        description: ^p.description,
        vendor_id: ^p.vendor_id,
        experience_id: ^p.experience_id)
      |> where([prod], like(prod.name, ^"#{p.name}%"))
      |> Repo.all

    # two products match that get_by
    assert match?([_, _], twins)
    clone = Enum.find(twins, &(&1.id != p.id))
    assert clone

    show_clone_url = admin_vendor_product_path(conn, :show, v, clone)
    assert redirected_to(conn) == show_clone_url

    conn = conn |> recycle_with_auth |> get(show_clone_url)
    response = html_response(conn, 200)
    assert response

    # cloned product correctly
    assert response =~ "#{p.name} Clone"
    assert response =~ p.description
    assert response =~ p.experience.name

    # cloned price amount
    assert response =~ "#{amount.amount}"
    assert response =~ "(&lt; #{amount.max_quantity})"

    # cloned default price
    assert response =~ "Current default"
    assert response =~ default_price.name
    assert response =~ default_price.description
    # cloned other price
    assert response =~ "Set as default"
    assert response =~ price.name
    assert response =~ price.description

    # cloned start time
    assert response =~ Ecto.Time.to_string(start_time.starts_at_time)
  end

end
