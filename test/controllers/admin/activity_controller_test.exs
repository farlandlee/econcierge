defmodule Grid.Admin.ActivityControllerTest do
  use Grid.ConnCase

  alias Grid.Activity
  @valid_attrs %{name: "some content", description: "some content"}
  @invalid_attrs %{name: "", description: ""}

  setup do
    {:ok, activity: Factory.create(:activity)}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, admin_activity_path(conn, :index)
    assert html_response(conn, 200) =~ "Activity Listing"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, admin_activity_path(conn, :new)

    response_body = html_response(conn, 200)
    assert response_body =~ "New Activity"
    assert response_body =~ "Name"
    assert response_body =~ "Description"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, admin_activity_path(conn, :create), activity: @valid_attrs
    assert redirected_to(conn) == admin_activity_path(conn, :index)
    assert Repo.get_by(Activity, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, admin_activity_path(conn, :create), activity: @invalid_attrs
    assert html_response(conn, 200) =~ "New Activity"
  end

  test "shows chosen resource", %{conn: conn, activity: activity} do
    conn = get conn, admin_activity_path(conn, :show, activity)

    response_body = html_response(conn, 200)
    assert response_body =~ "#{activity.name}"
    assert response_body =~ "#{activity.description}"

    assert response_body =~ "Images"
    assert response_body =~ "Add Image"
  end

  test "shows images", %{conn: conn, activity: a} do
    i = Factory.create_activity_image(assoc_id: a.id)
    no_alt_img = Factory.create_activity_image(assoc_id: a.id, alt: "")

    conn = get conn, admin_activity_path(conn, :show, a)
    response = html_response(conn, 200)
    assert response =~ "Images"
    assert response =~ "#{i.filename}"
    assert response =~ "#{i.alt}"
    assert response =~ "Set as default"

    assert response =~ "#{no_alt_img.filename}"
    assert response =~ "No caption"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, admin_activity_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn, activity: activity} do
    conn = get conn, admin_activity_path(conn, :edit, activity)

    response_body = html_response(conn, 200)
    assert response_body =~ "Edit Activity"
    assert response_body =~ "Name"
    assert response_body =~ "#{activity.name}"
    assert response_body =~ "Description"
    assert response_body =~ "#{activity.description}"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, activity: activity} do
    conn = put conn, admin_activity_path(conn, :update, activity), activity: @valid_attrs
    assert redirected_to(conn) == admin_activity_path(conn, :show, activity)
    assert Repo.get_by(Activity, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, activity: activity} do
    conn = put conn, admin_activity_path(conn, :update, activity), activity: @invalid_attrs

    response_body = html_response(conn, 200)
    assert response_body =~ "Edit Activity"
    assert response_body =~ "Name"
    assert response_body =~ "Description"
  end

  test "deletes chosen resource", %{conn: conn, activity: activity} do
    conn = delete conn, admin_activity_path(conn, :delete, activity)
    assert redirected_to(conn) == admin_activity_path(conn, :index)
    refute Repo.get(Activity, activity.id)
  end
end
