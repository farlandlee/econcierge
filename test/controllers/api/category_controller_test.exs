defmodule Grid.API.CategoryControllerTest do
  use Grid.ConnCase

  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup do
    experience
      = %{activity: activity}
      = Factory.create(:experience)

    category = Factory.create(:category, activity: activity)
    Factory.create(:experience_category, experience: experience, category: category)

    {:ok, category: category, activity: activity, experience: experience}
  end

  test "lists all entries with published products on index", %{conn: conn, category: category, experience: experience} do
    Factory.create(:product, experience: experience, published: true)

    conn = get conn, api_category_path(conn, :index)
    response = json_response(conn, 200)
    assert Enum.count(response["categories"]) == 1
    resp_category = hd(response["categories"])

    assert resp_category["id"] == category.id
    assert resp_category["name"] == category.name
    assert resp_category["description"] == category.description
    assert resp_category["slug"] == category.slug
  end

  test "no entries if no published products on index", %{conn: conn} do
    conn = get conn, api_category_path(conn, :index)
    response = json_response(conn, 200)
    assert Enum.count(response["categories"]) == 0
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
