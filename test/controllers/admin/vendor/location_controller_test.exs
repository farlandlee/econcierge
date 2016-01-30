defmodule Grid.LocationControllerTest do
  use Grid.ConnCase

  alias Grid.Location
  @valid_attrs %{name: "yeehaw", address1: "125 E Simpson", city: "Jackson", state: "WY", zip: "83001"}
  @invalid_attrs %{state: "not a real state"}

  setup do
    location = Factory.create(:location)
    {:ok, vendor: location.vendor, location: location}
  end

  test "redirects index to show vendor", %{conn: conn, vendor: vendor} do
    conn = get conn, admin_vendor_location_path(conn, :index, vendor)
    assert redirected_to(conn, 302) =~ admin_vendor_path(conn, :show, vendor, tab: "locations")
  end

  test "redirects show to show vendor", %{conn: conn, vendor: vendor} do
    conn = get conn, admin_vendor_location_path(conn, :index, vendor)
    assert redirected_to(conn, 302) =~ admin_vendor_path(conn, :show, vendor, tab: "locations")
  end

  test "renders page not found when id is nonexistent", %{conn: conn, vendor: vendor} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, admin_vendor_product_path(conn, :show, vendor, -1)
    end
  end

  test "renders form for new resources", %{conn: conn, vendor: vendor} do
    conn = get conn, admin_vendor_location_path(conn, :new, vendor)
    response = html_response(conn, 200)
    assert response =~ "New Location"
    assert response =~ "Name"
    assert response =~ "Address"
    assert response =~ "Address 2"
    assert response =~ "City"
    assert response =~ "State"
    assert response =~ "Zip"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, vendor: vendor} do
    conn = post conn, admin_vendor_location_path(conn, :create, vendor), location: @valid_attrs
    assert redirected_to(conn) == admin_vendor_location_path(conn, :index, vendor)
    assert Repo.get_by(Location, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, vendor: vendor} do
    conn = post conn, admin_vendor_location_path(conn, :create, vendor), location: @invalid_attrs
    response = html_response(conn, 200)
    assert response =~ "New Location"
    assert response =~ "can&#39;t be blank"
  end

  test "renders form for editing chosen resource", %{conn: conn, vendor: vendor, location: location} do
    conn = get conn, admin_vendor_location_path(conn, :edit, vendor, location)
    response = html_response(conn, 200)
    assert response =~ "Edit Location"
    assert response =~ "Name"
    assert response =~ location.name
    assert response =~ "Address"
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

  test "updates chosen resource and redirects when data is valid", %{conn: conn, vendor: vendor, location: location} do
    conn = put conn, admin_vendor_location_path(conn, :update, vendor, location), location: @valid_attrs
    assert redirected_to(conn) == admin_vendor_path(conn, :show, vendor, tab: "locations")
    assert Repo.get_by(Location, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, vendor: vendor, location: location} do
    conn = put conn, admin_vendor_location_path(conn, :update, vendor, location), location: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Location"
  end

  test "deletes chosen resource", %{conn: conn, vendor: vendor, location: location} do
    conn = delete conn, admin_vendor_location_path(conn, :delete, vendor, location)
    assert redirected_to(conn) == admin_vendor_path(conn, :show, vendor, tab: "locations")
    refute Repo.get(Location, location.id)
  end
end
