defmodule Grid.VendorControllerTest do
  use Grid.ConnCase

  alias Grid.Vendor
  alias Grid.Activity
  alias Grid.VendorActivity

  @valid_attrs %{description: "some content", name: "some content", activities: []}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, vendor_path(conn, :index)
    assert html_response(conn, 200) =~ "Vendor Listing"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, vendor_path(conn, :new)
    assert html_response(conn, 200) =~ "New Vendor"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, vendor_path(conn, :create), vendor: @valid_attrs
    assert redirected_to(conn) == vendor_path(conn, :index)
    assert Repo.get_by(Vendor, @valid_attrs |> Map.delete(:activities))
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, vendor_path(conn, :create), vendor: @invalid_attrs
    assert html_response(conn, 200) =~ "New Vendor"
  end

  test "shows chosen resource", %{conn: conn} do
    vendor = Repo.insert! %Vendor{}
    conn = get conn, vendor_path(conn, :show, vendor)
    assert html_response(conn, 200) =~ "Show Vendor"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, vendor_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    vendor = Repo.insert! %Vendor{}
    conn = get conn, vendor_path(conn, :edit, vendor)
    assert html_response(conn, 200) =~ "Edit Vendor"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    vendor = Repo.insert! %Vendor{}
    conn = put conn, vendor_path(conn, :update, vendor), vendor: @valid_attrs
    assert redirected_to(conn) == vendor_path(conn, :show, vendor)
    assert Repo.get_by(Vendor, @valid_attrs |> Map.delete(:activities))
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    vendor = Repo.insert!(%Vendor{name: "Test"})
    activity = Repo.insert!(%Activity{name: "Fly Fishing"})
    Repo.insert!(%VendorActivity{
      vendor_id: vendor.id,
      activity_id: activity.id
    })

    conn = put conn, vendor_path(conn, :update, vendor), vendor: @invalid_attrs

    response = html_response(conn, 200)
    assert response =~ ~s(name="vendor[name]" type="text" value="Test")
    assert response =~ ~s(<option selected="selected" value="#{activity.id}">Fly Fishing</option></select>)
  end

  test "deletes chosen resource", %{conn: conn} do
    vendor = Repo.insert! %Vendor{}
    conn = delete conn, vendor_path(conn, :delete, vendor)
    assert redirected_to(conn) == vendor_path(conn, :index)
    refute Repo.get(Vendor, vendor.id)
  end
end
