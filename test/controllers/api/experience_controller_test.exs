defmodule Grid.Api.ExperienceControllerTest do
  use Grid.ConnCase

  @valid_attrs %{}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  setup do
    %{experience: exp, category: cat}
      = Factory.create(:experience_category)
    {:ok, experience: exp, category: cat}
  end

  test "index lists all entries", %{conn: conn, experience: experience} do
    conn = get conn, api_experience_path(conn, :index)
    response = json_response(conn, 200)
    assert Enum.count(response["experiences"]) == 1
    resp_experience = hd(response["experiences"])

    assert resp_experience["id"] == experience.id
    assert resp_experience["name"] == experience.name
    assert resp_experience["description"] == experience.description
    assert resp_experience["slug"] == experience.slug
  end

  test "index filters by category_id", %{conn: conn, experience: experience, category: cat} do
    conn = get conn, api_experience_path(conn, :index, category_id: cat.id)
    response = json_response(conn, 200)
    assert Enum.count(response["experiences"]) == 1
    resp_experience = hd(response["experiences"])

    assert resp_experience["id"] == experience.id
    assert resp_experience["name"] == experience.name
    assert resp_experience["description"] == experience.description
    assert resp_experience["slug"] == experience.slug

    conn = get conn, api_experience_path(conn, :index, category_id: -1)
    assert json_response(conn, 200)["experiences"] == []
  end

  test "index filters by (product) date", %{conn: conn} do
    %{product: %{experience: experience}} =
      Factory.create_start_time(season: Factory.create(:season,
        start_date_month: 4, start_date_day: 2,
        end_date_month: 6, end_date_day: 15
      ))
    conn = get conn, api_experience_path(conn, :index, date: "2017-05-02")
    response = json_response(conn, 200)
    assert Enum.count(response["experiences"]) == 1
    resp_experience = hd(response["experiences"])

    assert resp_experience["id"] == experience.id
    assert resp_experience["name"] == experience.name
    assert resp_experience["description"] == experience.description
    assert resp_experience["slug"] == experience.slug

    # expired dates are ignored, shows all experiences
    conn = get conn, api_experience_path(conn, :index, date: "2014-01-01")
    assert json_response(conn, 200)["experiences"] == []

    # empty date renders nothing
    conn = get conn, api_experience_path(conn, :index, date: "2017-07-01")
    assert json_response(conn, 200)["experiences"] == []
  end

  test "shows chosen resource by slug", %{conn: conn, experience: experience} do
    conn = get conn, api_experience_path(conn, :show, experience.slug)
    response = json_response(conn, 200)
    resp_experience = response["experience"]

    assert resp_experience
    assert resp_experience["id"] == experience.id
    assert resp_experience["name"] == experience.name
    assert resp_experience["description"] == experience.description
    assert resp_experience["slug"] == experience.slug
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, api_experience_path(conn, :show, -1)
    end
  end
end
