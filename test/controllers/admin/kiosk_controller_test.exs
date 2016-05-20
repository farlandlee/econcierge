defmodule Grid.Admin.KioskControllerTest do
  use Grid.ConnCase

  alias Grid.Kiosk
  @valid_attrs %{name: "some content", sub_domain: "some-content"}
  @invalid_attrs %{name: ""}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, admin_kiosk_path(conn, :index)
    assert html_response(conn, 200) =~ "Kiosk Listing"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, admin_kiosk_path(conn, :new)
    assert html_response(conn, 200) =~ "New Kiosk"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, admin_kiosk_path(conn, :create), kiosk: @valid_attrs
    assert redirected_to(conn) == admin_kiosk_path(conn, :index)
    assert Repo.get_by(Kiosk, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, admin_kiosk_path(conn, :create), kiosk: @invalid_attrs
    assert html_response(conn, 200) =~ "New Kiosk"
  end

  test "shows chosen resource", %{conn: conn} do
    kiosk = Factory.create(:kiosk)
    conn = get conn, admin_kiosk_path(conn, :show, kiosk)
    assert html_response(conn, 200) =~ "Show Kiosk"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, admin_kiosk_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    kiosk = Factory.create(:kiosk)
    conn = get conn, admin_kiosk_path(conn, :edit, kiosk)
    assert html_response(conn, 200) =~ "Edit Kiosk"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    kiosk = Factory.create(:kiosk)
    conn = put conn, admin_kiosk_path(conn, :update, kiosk), kiosk: @valid_attrs
    assert redirected_to(conn) == admin_kiosk_path(conn, :show, kiosk)
    assert Repo.get_by(Kiosk, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    kiosk = Factory.create(:kiosk)
    conn = put conn, admin_kiosk_path(conn, :update, kiosk), kiosk: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Kiosk"
  end

  test "deletes chosen resource", %{conn: conn} do
    kiosk = Factory.create(:kiosk)
    conn = delete conn, admin_kiosk_path(conn, :delete, kiosk)
    assert redirected_to(conn) == admin_kiosk_path(conn, :index)
    refute Repo.get(Kiosk, kiosk.id)
  end
end
