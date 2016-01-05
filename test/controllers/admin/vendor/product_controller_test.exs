defmodule Grid.Admin.ProductControllerTest do
  use Grid.ConnCase

  alias Grid.Activity
  alias Grid.ActivityCategory
  alias Grid.Category
  alias Grid.Product
  alias Grid.ProductActivityCategory
  alias Grid.Vendor
  alias Grid.VendorActivity

  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{name: ""}

  setup do
    p = Factory.create(:product)

    Repo.insert!(%VendorActivity{vendor_id: p.vendor.id, activity_id: p.activity.id})

    c = Factory.create(:category)
    ac = Repo.insert!(%ActivityCategory{
      activity_id: p.activity.id,
      category_id: c.id
    })

    Repo.insert! %ProductActivityCategory{
      activity_category_id: ac.id,
      product_id: p.id
    }

    {:ok,
      product: p,
      vendor: p.vendor,
      activity: p.activity,
      category: c,
      activity_category: ac
    }
  end

  test "only shows products belonging to vendor", %{conn: conn, vendor: v, activity: a} do
    v2 = Repo.insert! %Vendor{name: "Other Vendor", description: "foobarbaz"}
    #setup
    p = Product.changeset(%Product{}, %{name: "don't show", description: "meow"})
    |> Ecto.Changeset.put_change(:vendor_id, v2.id)
    |> Ecto.Changeset.put_change(:activity_id, a.id)
    |> Repo.insert!

    conn = get conn, admin_vendor_product_path(conn, :index, v)
    response = html_response(conn, 200)
    refute response =~ p.name
    refute response =~ p.description

    Repo.delete! v2
  end

  test "lists all entries on index", %{conn: conn, vendor: v, product: p, activity: a} do
    conn = get conn, admin_vendor_product_path(conn, :index, v)
    response = html_response(conn, 200)
    assert response =~ "#{v.name} Products"
    assert response =~ "Name"
    assert response =~ "Activity"
    assert response =~ "Description"
    assert response =~ "Published?"

    assert response =~ a.name
    assert response =~ p.name
    assert response =~ p.description
  end

  test "renders form for new resources", %{conn: conn, vendor: v, category: c, activity: a} do
    conn = get conn, admin_vendor_product_path(conn, :new, v.id)
    response = html_response(conn, 200)
    assert response =~ "New Product"
    assert response =~ "Name"
    assert response =~ "Description"
    assert response =~ "Published"
    assert response =~ "Activity &amp; Category"
    assert response =~ "#{a.name} | #{c.name}"
  end

  test "filters activity categories by vendor activities", %{conn: conn, vendor: v, product: p} do
    activity = Repo.insert! %Activity{name: "dontshow", description: "nodesc"}
    category = Repo.insert! %Category{name: "NEVER"}
    Repo.insert! %ActivityCategory{activity_id: activity.id, category_id: category.id}

    conn = get conn, admin_vendor_product_path(conn, :new, v)
    response = html_response(conn, 200)
    refute response =~ "#{activity.name} | #{category.name}"

    conn = conn |> recycle |> get(admin_vendor_product_path(conn, :edit, v, p))
    response = html_response(conn, 200)
    refute response =~ "#{activity.name} | #{category.name}"

    [activity, category] |> Enum.map(&Repo.delete!/1)
  end


  test "creates resource and redirects when data is valid", %{conn: conn, vendor: v, activity_category: ac} do
    valid_attrs = @valid_attrs |> Map.put(:activity_categories, [ac.id])
    conn = post conn, admin_vendor_product_path(conn, :create, v), product: valid_attrs
    assert redirected_to(conn) == admin_vendor_product_path(conn, :index, v)
    assert Repo.get_by(Product, @valid_attrs)
  end

  test "does not create resource and redirects when no activity category is selected", %{conn: conn, vendor: v} do
    conn = post conn, admin_vendor_product_path(conn, :create, v), product: @invalid_attrs
    assert redirected_to(conn) == admin_vendor_product_path(conn, :new, v)
  end

  test "does not create resource and renders errors when params are invalid", %{conn: conn, vendor: v, activity_category: ac} do
    conn = post conn, admin_vendor_product_path(conn, :create, v), product: Map.put(@invalid_attrs, :activity_categories, [ac.id])
    assert html_response(conn, 200) =~ "New Product"
  end

  test "shows chosen resource", %{conn: conn, vendor: v, product: p, category: c, activity: a} do
    conn = get conn, admin_vendor_product_path(conn, :show, v, p)
    response = html_response(conn, 200)
    assert response =~ "Name:"
    assert response =~ "#{p.name}"
    assert response =~ "Description:"
    assert response =~ "#{p.description}"
    assert response =~ "Activity:"
    assert response =~ "#{a.name}"
    assert response =~ "Categories"
    assert response =~ "#{c.name}"
    # has link to edit
    assert response =~ "Edit Product"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, vendor: v} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, admin_vendor_product_path(conn, :show, v, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, vendor: v, product: p, category: c, activity: a} do
    conn = get conn, admin_vendor_product_path(conn, :edit, v, p)
    response = html_response(conn, 200)
    assert response =~ "Edit Product"
    assert response =~ "Name"
    assert response =~ "#{p.name}"
    assert response =~ "Description"
    assert response =~ "#{p.description}"
    assert response =~ "Activity &amp; Category"
    assert response =~ "#{a.name} | #{c.name}"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, vendor: v, product: p, activity: a} do
    c = Repo.insert!(%Category{name: "All night long, all night."})
    ac = Repo.insert!(%ActivityCategory{
      activity_id: a.id,
      category_id: c.id
    })
    update_params = %{
      name: "poopies",
      description: "wahoo",
      activity_categories: [ac.id]
    }

    conn = put conn, admin_vendor_product_path(conn, :update, v, p), product: update_params
    assert redirected_to(conn) == admin_vendor_product_path(conn, :show, v, p)
    assert Repo.get_by(Product, update_params |> Map.take([:name, :description]))

    pac = assert Repo.one!(from pac in ProductActivityCategory, where: pac.product_id == ^p.id)
    assert pac.activity_category_id == ac.id
  end

  test "poops the bed and redirects when you update without activity categories", %{conn: conn, vendor: v, product: p} do
    conn = put conn, admin_vendor_product_path(conn, :update, v, p), product: @valid_attrs
    assert redirected_to(conn) == admin_vendor_product_path(conn, :edit, v, p)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, vendor: v, product: p, activity_category: ac} do
    conn = put conn, admin_vendor_product_path(conn, :update, v, p), product: Map.put(@invalid_attrs, :activity_categories, [ac.id])
    assert html_response(conn, 200) =~ "Edit Product"
  end


  test "deletes chosen resource", %{conn: conn, vendor: v, product: p} do
    conn = delete conn, admin_vendor_product_path(conn, :delete, v, p)
    assert redirected_to(conn) == admin_vendor_product_path(conn, :index, v)
    refute Repo.get(Product, p.id)
  end
end
