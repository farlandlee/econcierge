defmodule Grid.ActivityControllerTest do
  use Grid.ConnCase

  alias Grid.Activity
  @valid_attrs %{name: "some content", description: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, activity_path(conn, :index)
    assert html_response(conn, 200) =~ "Activity Listing"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, activity_path(conn, :new)

    response_body = html_response(conn, 200)
    assert response_body =~ "New Activity"
    assert response_body =~ "Name"
    assert response_body =~ "Description"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, activity_path(conn, :create), activity: @valid_attrs
    assert redirected_to(conn) == activity_path(conn, :index)
    assert Repo.get_by(Activity, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, activity_path(conn, :create), activity: @invalid_attrs
    assert html_response(conn, 200) =~ "New Activity"
  end

  test "shows chosen resource", %{conn: conn} do
    activity = Repo.insert! %Activity{}
    conn = get conn, activity_path(conn, :show, activity)

    response_body = html_response(conn, 200)
    assert response_body =~ "Show Activity"
    assert response_body =~ "Name"
    assert response_body =~ "Description"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, activity_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    activity = Repo.insert! %Activity{}
    conn = get conn, activity_path(conn, :edit, activity)

    response_body = html_response(conn, 200)
    assert response_body =~ "Edit Activity"
    assert response_body =~ "Name"
    assert response_body =~ "Description"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    activity = Repo.insert! %Activity{}
    conn = put conn, activity_path(conn, :update, activity), activity: @valid_attrs
    assert redirected_to(conn) == activity_path(conn, :show, activity)
    assert Repo.get_by(Activity, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    activity = Repo.insert! %Activity{}
    conn = put conn, activity_path(conn, :update, activity), activity: @invalid_attrs

    response_body = html_response(conn, 200)
    assert response_body =~ "Edit Activity"
    assert response_body =~ "Name"
    assert response_body =~ "Description"
  end

  test "deletes chosen resource", %{conn: conn} do
    activity = Repo.insert! %Activity{}
    conn = delete conn, activity_path(conn, :delete, activity)
    assert redirected_to(conn) == activity_path(conn, :index)
    refute Repo.get(Activity, activity.id)
  end
end
