defmodule Grid.Admin.Activity.AmenityControllerTest do
  use Grid.ConnCase

  alias Grid.Amenity
  @valid_attrs %{name: "Test"}
  @invalid_attrs %{name: nil}

  setup do
    amentity = %{activity: activity} = Factory.create(:amenity)

    {:ok, amenity: amentity, activity: activity}
  end

  test "index redirects to activity show", %{conn: conn, activity: a} do
    conn = get conn, admin_activity_amenity_path(conn, :index, a)
    assert redirected_to(conn) == admin_activity_path(conn, :show, a, tab: "amenities")
  end

  test "renders form for new resources", %{conn: conn, activity: a} do
    conn = get conn, admin_activity_amenity_path(conn, :new, a)
    assert html_response(conn, 200) =~ "New Amenity"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, activity: a} do
    conn = post conn, admin_activity_amenity_path(conn, :create, a), amenity: @valid_attrs
    assert redirected_to(conn) == admin_activity_path(conn, :show, a)
    assert Repo.get_by(Amenity, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, activity: a} do
    conn = post conn, admin_activity_amenity_path(conn, :create, a), amenity: @invalid_attrs
    assert html_response(conn, 200) =~ "New Amenity"
  end

  test "shows chosen resource", %{conn: conn, activity: activity, amenity: amenity} do
    conn = get conn, admin_activity_amenity_path(conn, :show, activity, amenity)
    assert html_response(conn, 200) =~ amenity.name
  end

  test "renders page not found when id is nonexistent", %{conn: conn, activity: activity} do
    assert_error_sent 404, fn ->
      get conn, admin_activity_amenity_path(conn, :show, activity, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, activity: activity, amenity: amenity} do
    conn = get conn, admin_activity_amenity_path(conn, :edit, activity, amenity)
    assert html_response(conn, 200) =~ "Edit Amenity"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, activity: activity, amenity: amenity} do
    conn = put conn, admin_activity_amenity_path(conn, :update, activity, amenity), amenity: @valid_attrs
    assert redirected_to(conn) == admin_activity_path(conn, :show, activity)
    assert Repo.get_by(Amenity, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, activity: activity, amenity: amenity} do
    conn = put conn, admin_activity_amenity_path(conn, :update, activity, amenity), amenity: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Amenity"
  end

  test "deletes chosen resource", %{conn: conn, activity: activity, amenity: amenity} do
    conn = delete conn, admin_activity_amenity_path(conn, :delete, activity, amenity)
    assert redirected_to(conn) == admin_activity_path(conn, :show, activity)
    refute Repo.get(Amenity, amenity.id)
  end
end
