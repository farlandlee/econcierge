defmodule Grid.Api.CategoryControllerTest do
  use Grid.ConnCase

  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup do
    category
      = %{activity: activity}
      = Factory.create(:category)
    {:ok, category: category, activity: activity}
  end

  test "lists all entries on index", %{conn: conn, category: category} do
    conn = get conn, api_category_path(conn, :index)
    response = json_response(conn, 200)
    assert Enum.count(response["categories"]) == 1
    resp_category = hd(response["categories"])

    assert resp_category["id"] == category.id
    assert resp_category["name"] == category.name
    assert resp_category["description"] == category.description
    assert resp_category["slug"] == category.slug
  end

  test "shows chosen resource", %{conn: conn, category: category} do
    conn = get conn, api_category_path(conn, :show, category.slug)
    response = json_response(conn, 200)
    resp_category = response["category"]

    assert resp_category
    assert resp_category["id"] == category.id
    assert resp_category["name"] == category.name
    assert resp_category["description"] == category.description
    assert resp_category["slug"] == category.slug
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, api_category_path(conn, :show, -1)
    end
  end
end
