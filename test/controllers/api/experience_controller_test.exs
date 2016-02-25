defmodule Grid.Api.ExperienceControllerTest do
  use Grid.ConnCase

  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup do
    a = Factory.create(:activity)
    i = Factory.create_activity_image(assoc_id: a.id)


    experience = Factory.create(:experience, activity: a, image: i)

    category = Factory.create(:category, activity: a)
    Factory.create(:experience_category,
      experience: experience,
      category: category
    )

    Factory.create(:product, experience: experience, published: true)

    {:ok, experience: experience, category: category, image: i}
  end

  test "index lists all entries", %{conn: conn} do
    conn = get conn, api_experience_path(conn, :index)
    response = json_response(conn, 200)
    assert Enum.count(response["experiences"]) == 1
  end

  test "index filters by category_id", %{conn: conn, category: cat} do
    conn = get conn, api_experience_path(conn, :index, category_id: cat.id)
    response = json_response(conn, 200)
    assert Enum.count(response["experiences"]) == 1

    conn = get conn, api_experience_path(conn, :index, category_id: -1)
    assert json_response(conn, 200)["experiences"] == []
  end

  test "shows chosen resource by id", %{conn: conn, experience: experience} do
    conn = get conn, api_experience_path(conn, :show, experience.id)
    assert json_response(conn, 200)
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, api_experience_path(conn, :show, -1)
    end
  end
end
