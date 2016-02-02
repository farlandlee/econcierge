defmodule Grid.Admin.Vendor.VendorActivity.SeasonControllerTest do
  use Grid.ConnCase

  alias Grid.Season
  @valid_attrs %{end_date_day: 1, end_date_month: 9, name: "some content", start_date_day: 6, start_date_month: 1}
  @invalid_attrs %{name: ""}

  setup do
    season
      = %{vendor_activity: va = %{
          vendor: vendor, activity: activity
        }}
      = Factory.create(:season)
    {:ok, season: season, vendor: vendor, activity: activity, vendor_activity: va}
  end

  test "index redirects to show vendor activity", %{conn: conn, vendor: vendor, vendor_activity: va} do
    conn = get conn, admin_vendor_vendor_activity_season_path(conn, :index, vendor, va)
    assert redirected_to(conn, 302) =~ admin_vendor_vendor_activity_path(conn, :show, vendor, va)
  end

  test "shows redirects to show vendor activity", %{conn: conn, vendor: vendor, vendor_activity: va, season: season} do
    conn = get conn, admin_vendor_vendor_activity_season_path(conn, :show, vendor, va, season)
    assert redirected_to(conn, 302) =~ admin_vendor_vendor_activity_path(conn, :show, vendor, va)
  end

  test "renders form for new resources", %{conn: conn, vendor: vendor, vendor_activity: va} do
    conn = get conn, admin_vendor_vendor_activity_season_path(conn, :new, vendor, va)
    assert html_response(conn, 200) =~ "New Season"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, vendor: vendor, vendor_activity: va} do
    valid_attrs = @valid_attrs |> Map.put(:vendor_activity_id, va.id)
    conn = post conn, admin_vendor_vendor_activity_season_path(conn, :create, vendor, va), season: valid_attrs
    assert redirected_to(conn) == admin_vendor_vendor_activity_path(conn, :show, vendor, va)
    assert Repo.get_by(Season, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, vendor: vendor, vendor_activity: va} do
    conn = post conn, admin_vendor_vendor_activity_season_path(conn, :create, vendor, va), season: @invalid_attrs
    assert html_response(conn, 200) =~ "New Season"
  end

  test "renders page not found when id is nonexistent", %{conn: conn, vendor: vendor, vendor_activity: va} do
    assert_error_sent 404, fn ->
      get conn, admin_vendor_vendor_activity_season_path(conn, :show, vendor, va, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, vendor: vendor, vendor_activity: va, season: season} do
    conn = get conn, admin_vendor_vendor_activity_season_path(conn, :edit, vendor, va, season)
    assert html_response(conn, 200) =~ "Edit Season"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, vendor: vendor, vendor_activity: va, season: season} do
    conn = put conn, admin_vendor_vendor_activity_season_path(conn, :update, vendor, va, season), season: @valid_attrs
    assert redirected_to(conn) == admin_vendor_vendor_activity_path(conn, :show, vendor, va)
    assert Repo.get_by(Season, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, vendor: vendor, vendor_activity: va, season: season} do
    conn = put conn, admin_vendor_vendor_activity_season_path(conn, :update, vendor, va, season), season: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Season"
  end

  test "deletes chosen resource", %{conn: conn, vendor: vendor, vendor_activity: va, season: season} do
    conn = delete conn, admin_vendor_vendor_activity_season_path(conn, :delete, vendor, va, season)
    assert redirected_to(conn) == admin_vendor_vendor_activity_path(conn, :show, vendor, va)
    refute Repo.get(Season, season.id)
  end
end
