defmodule Grid.Admin.VendorControllerTest do
  use Grid.ConnCase

  alias Grid.Vendor

  @valid_attrs %{description: "some content", name: "some content", tripadvisor_location_id: "394873528"}
  @invalid_attrs %{name: ""}

  setup do
    %{vendor: vendor, activity: activity}
      = Factory.create(:vendor_activity)
    {:ok, vendor: vendor, activity: activity}
  end

  test "lists all entries on index", %{conn: conn, vendor: vendor, activity: activity} do
    other_vendor = Factory.create(:vendor)
    conn = get conn, admin_vendor_path(conn, :index)
    response = html_response(conn, 200)

    assert response =~ "Vendor Listing"
    assert response =~ "Filter by Activity"
    assert response =~ vendor.name
    assert response =~ vendor.description
    assert response =~ activity.name
    assert response =~ other_vendor.name
    assert response =~ other_vendor.description
  end

  test "Filters by activity", %{conn: conn, vendor: vendor, activity: activity} do
    %{vendor: other_vendor, activity: other_activity} = Factory.create(:vendor_activity)

    conn = get conn, admin_vendor_path(conn, :index, activity_id: activity.id)
    response = html_response(conn, 200)

    assert response =~ "Vendor Listing"
    assert response =~ vendor.name
    assert response =~ vendor.description
    assert response =~ "Clear Filter"
    assert response =~ other_activity.name

    refute response =~ other_vendor.name
    refute response =~ other_vendor.description
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, admin_vendor_path(conn, :new)
    assert html_response(conn, 200) =~ "New Vendor"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, admin_vendor_path(conn, :create), vendor: @valid_attrs
    vendor = Repo.get_by(Vendor, @valid_attrs |> Map.delete(:activities))
    assert vendor
    assert redirected_to(conn) == admin_vendor_path(conn, :show, vendor)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, admin_vendor_path(conn, :create), vendor: @invalid_attrs
    assert html_response(conn, 200) =~ "New Vendor"
  end

  test "shows chosen resource", %{conn: conn, vendor: vendor} do
    conn = get conn, admin_vendor_path(conn, :show, vendor)
    assert html_response(conn, 200) =~ "#{vendor.name}"
  end

  test "shows locations", %{conn: conn} do
    location = Factory.create(:location)
    conn = get conn, admin_vendor_path(conn, :show, location.vendor, tab: "locations")
    response = html_response(conn, 200)
    assert response =~ "Locations"
    assert response =~ "Name"
    assert response =~ location.name
    assert response =~ "Address 1"
    assert response =~ location.address1
    assert response =~ "Address 2"
    assert response =~ location.address2
    assert response =~ "City"
    assert response =~ location.city
    assert response =~ "State"
    assert response =~ location.state
    assert response =~ "Zip"
    assert response =~ location.zip
  end

  test "shows images", %{conn: conn, vendor: v} do
    i = Factory.create_vendor_image(assoc_id: v.id)
    no_alt_img = Factory.create_vendor_image(assoc_id: v.id, alt: "")

    conn = get conn, admin_vendor_path(conn, :show, v, tab: "images")
    response = html_response(conn, 200)
    assert response =~ "Images"
    assert response =~ "Add Image"
    assert response =~ "#{i.filename}"
    assert response =~ "#{i.alt}"
    assert response =~ "Set as default"

    assert response =~ "#{no_alt_img.filename}"
    assert response =~ "No caption"
  end

  test "shows products", %{conn: conn, vendor: vendor} do
    product = Factory.create(:product, vendor: vendor)
    experience = product.experience
    conn = get conn, admin_vendor_path(conn, :show, vendor, tab: "products")
    response = html_response(conn, 200)
    assert response =~ "Products"
    assert response =~ "Add Product"
    assert response =~ "Name"
    assert response =~ "Experience"
    assert response =~ "Description"
    assert response =~ "Published?"

    assert response =~ experience.name
    assert response =~ product.name
    assert response =~ product.description
  end

  test "Shows seasons", %{conn: conn} do
    import Grid.Admin.Vendor.VendorActivity.SeasonView,
      only: [start_date: 1, end_date: 1]
    season
      = %{vendor_activity: %{vendor: vendor, activity: activity}}
      = Factory.create(:season)
    conn = get conn, admin_vendor_path(conn, :show, vendor, tab: "seasons")
    response = html_response(conn, 200)

    assert response =~ "Seasons"
    assert response =~ "Add Season"
    assert response =~ "Name"
    assert response =~ "Activity"
    assert response =~ "Start date"
    assert response =~ "End date"

    assert response =~ activity.name
    assert response =~ start_date season
    assert response =~ end_date season
  end

  test "only shows products belonging to this vendor", %{conn: conn, vendor: v} do
    other_vendors_product = Factory.build(:product)

    conn = get conn, admin_vendor_path(conn, :show, v)
    response = html_response(conn, 200)
    refute response =~ other_vendors_product.name
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, admin_vendor_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, vendor: vendor} do
    conn = get conn, admin_vendor_path(conn, :edit, vendor)
    assert html_response(conn, 200) =~ "Edit Vendor"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, vendor: vendor} do
    conn = put conn, admin_vendor_path(conn, :update, vendor), vendor: @valid_attrs
    assert redirected_to(conn) == admin_vendor_path(conn, :show, vendor)
    assert Repo.get_by(Vendor, @valid_attrs |> Map.delete(:activities))
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, vendor: vendor} do
    conn = put conn, admin_vendor_path(conn, :update, vendor), vendor: @invalid_attrs

    assert html_response(conn, 200) =~ "Edit Vendor"
  end

  test "deletes chosen resource", %{conn: conn} do
    vendor = Factory.create(:vendor)
    conn = delete conn, admin_vendor_path(conn, :delete, vendor)
    assert redirected_to(conn) == admin_vendor_path(conn, :index)
    refute Repo.get(Vendor, vendor.id)
  end
end
