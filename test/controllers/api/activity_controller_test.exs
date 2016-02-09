defmodule Grid.API.ActivityControllerTest do
  use Grid.ConnCase

  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup do
    {:ok, activity: Factory.create(:activity)}
  end

  test "lists all entries on index", %{conn: conn, activity: activity} do
    conn = get conn, api_activity_path(conn, :index)
    response = json_response(conn, 200)
    assert Enum.count(response["activities"]) == 1
    resp_activity = hd(response["activities"])

    assert resp_activity["id"] == activity.id
    assert resp_activity["name"] == activity.name
    assert resp_activity["description"] == activity.description
    assert resp_activity["slug"] == activity.slug
  end

  test "shows chosen resource by slug", %{conn: conn, activity: activity} do
    conn = get conn, api_activity_path(conn, :show, activity.slug)
    response = json_response(conn, 200)
    resp_activity = response["activity"]

    assert resp_activity
    assert resp_activity["id"] == activity.id
    assert resp_activity["name"] == activity.name
    assert resp_activity["description"] == activity.description
    assert resp_activity["slug"] == activity.slug
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, api_activity_path(conn, :show, "foo")
    end
  end
end