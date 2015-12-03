defmodule Grid.VendorControllerTest do
  use Grid.ConnCase

  alias Grid.Vendor
  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, vendor_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing vendors"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, vendor_path(conn, :new)
    assert html_response(conn, 200) =~ "New vendor"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, vendor_path(conn, :create), vendor: @valid_attrs
    assert redirected_to(conn) == vendor_path(conn, :index)
    assert Repo.get_by(Vendor, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, vendor_path(conn, :create), vendor: @invalid_attrs
    assert html_response(conn, 200) =~ "New vendor"
  end

  test "shows chosen resource", %{conn: conn} do
    vendor = Repo.insert! %Vendor{}
    conn = get conn, vendor_path(conn, :show, vendor)
    assert html_response(conn, 200) =~ "Show vendor"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, vendor_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    vendor = Repo.insert! %Vendor{}
    conn = get conn, vendor_path(conn, :edit, vendor)
    assert html_response(conn, 200) =~ "Edit vendor"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    vendor = Repo.insert! %Vendor{}
    conn = put conn, vendor_path(conn, :update, vendor), vendor: @valid_attrs
    assert redirected_to(conn) == vendor_path(conn, :show, vendor)
    assert Repo.get_by(Vendor, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    vendor = Repo.insert! %Vendor{}
    conn = put conn, vendor_path(conn, :update, vendor), vendor: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit vendor"
  end

  test "deletes chosen resource", %{conn: conn} do
    vendor = Repo.insert! %Vendor{}
    conn = delete conn, vendor_path(conn, :delete, vendor)
    assert redirected_to(conn) == vendor_path(conn, :index)
    refute Repo.get(Vendor, vendor.id)
  end
end
