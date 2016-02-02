defmodule Grid.Admin.Activity.AmenityOptionControllerTest do
  use Grid.ConnCase

  alias Grid.AmenityOption
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{name: ""}

  setup do
    amenity_option = Factory.create(:amenity_option)

    {
      :ok,
      amenity: amenity_option.amenity,
      activity: amenity_option.amenity.activity,
      amenity_option: amenity_option
    }
  end

  test "index redirects to amenity show", %{conn: conn, activity: activity, amenity: amenity} do
    conn = get conn, admin_activity_amenity_amenity_option_path(conn, :index, activity, amenity)
    assert redirected_to(conn) == admin_activity_amenity_path(conn, :show, activity, amenity)
  end

  test "show redirects to amenity show", %{conn: conn, activity: activity, amenity: amenity, amenity_option: ao} do
    conn = get conn, admin_activity_amenity_amenity_option_path(conn, :show, activity, amenity, ao)
    assert redirected_to(conn) == admin_activity_amenity_path(conn, :show, activity, amenity)
  end

  test "renders form for new resources", %{conn: conn, activity: activity, amenity: amenity} do
    conn = get conn, admin_activity_amenity_amenity_option_path(conn, :new, activity, amenity)
    assert html_response(conn, 200) =~ "New Amenity Option"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, activity: activity, amenity: amenity} do
    conn = post conn, admin_activity_amenity_amenity_option_path(conn, :create, activity, amenity), amenity_option: @valid_attrs
    assert redirected_to(conn) == admin_activity_amenity_path(conn, :show, activity, amenity)
    assert Repo.get_by(AmenityOption, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, activity: activity, amenity: amenity} do
    conn = post conn, admin_activity_amenity_amenity_option_path(conn, :create, activity, amenity), amenity_option: @invalid_attrs
    assert html_response(conn, 200) =~ "New Amenity Option"
  end


  test "renders form for editing chosen resource", %{conn: conn, activity: activity, amenity: amenity, amenity_option: amenity_option} do
    conn = get conn, admin_activity_amenity_amenity_option_path(conn, :edit, activity, amenity, amenity_option)
    assert html_response(conn, 200) =~ "Edit Amenity Option"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, activity: activity, amenity: amenity, amenity_option: amenity_option} do
    conn = put conn, admin_activity_amenity_amenity_option_path(conn, :update, activity, amenity, amenity_option), amenity_option: @valid_attrs
    assert redirected_to(conn) == admin_activity_amenity_path(conn, :show, activity, amenity)
    assert Repo.get_by(AmenityOption, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, activity: activity, amenity: amenity, amenity_option: amenity_option} do
    conn = put conn, admin_activity_amenity_amenity_option_path(conn, :update, activity, amenity, amenity_option), amenity_option: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Amenity Option"
  end

  test "deletes chosen resource", %{conn: conn, activity: activity, amenity: amenity, amenity_option: amenity_option} do
    conn = delete conn, admin_activity_amenity_amenity_option_path(conn, :delete, activity, amenity, amenity_option)
    assert redirected_to(conn) == admin_activity_amenity_path(conn, :show, activity, amenity)
    refute Repo.get(AmenityOption, amenity_option.id)
  end
end
