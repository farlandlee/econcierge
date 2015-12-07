defmodule Grid.ActivityTypeControllerTest do
  use Grid.ConnCase

  alias Grid.ActivityType
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, activity_type_path(conn, :index)
    assert html_response(conn, 200) =~ "Activity Type Listing"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, activity_type_path(conn, :new)
    assert html_response(conn, 200) =~ "New Activity Type"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, activity_type_path(conn, :create), activity_type: @valid_attrs
    assert redirected_to(conn) == activity_type_path(conn, :index)
    assert Repo.get_by(ActivityType, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, activity_type_path(conn, :create), activity_type: @invalid_attrs
    assert html_response(conn, 200) =~ "New Activity Type"
  end

  test "shows chosen resource", %{conn: conn} do
    activity_type = Repo.insert! %ActivityType{}
    conn = get conn, activity_type_path(conn, :show, activity_type)
    assert html_response(conn, 200) =~ "Show Activity Type"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, activity_type_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    activity_type = Repo.insert! %ActivityType{}
    conn = get conn, activity_type_path(conn, :edit, activity_type)
    assert html_response(conn, 200) =~ "Edit Activity Type"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    activity_type = Repo.insert! %ActivityType{}
    conn = put conn, activity_type_path(conn, :update, activity_type), activity_type: @valid_attrs
    assert redirected_to(conn) == activity_type_path(conn, :show, activity_type)
    assert Repo.get_by(ActivityType, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    activity_type = Repo.insert! %ActivityType{}
    conn = put conn, activity_type_path(conn, :update, activity_type), activity_type: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Activity Type"
  end

  test "deletes chosen resource", %{conn: conn} do
    activity_type = Repo.insert! %ActivityType{}
    conn = delete conn, activity_type_path(conn, :delete, activity_type)
    assert redirected_to(conn) == activity_type_path(conn, :index)
    refute Repo.get(ActivityType, activity_type.id)
  end
end
