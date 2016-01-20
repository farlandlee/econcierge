defmodule Grid.Admin.Activity.ExperienceControllerTest do
  use Grid.ConnCase

  alias Grid.Experience
  @valid_attrs %{
    name: "Some Name",
    description: "Some Description"
  }

  @invalid_attrs %{}

  setup do
    e = Factory.create(:experience)
    Factory.create(:experience_category, experience: e)

    {:ok,
      experience: e,
      activity: Factory.create(:activity)
    }
  end

  test "renders form for new resources", %{conn: conn, activity: a} do
    conn = get conn, admin_activity_experience_path(conn, :new, a)
    assert html_response(conn, 200) =~ "New Experience"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, activity: a} do
    c = Factory.create(:category)
    attrs = Map.put(@valid_attrs, :category_id, ["#{c.id}"])

    conn = post conn, admin_activity_experience_path(conn, :create, a), experience: attrs

    assert redirected_to(conn) == admin_activity_path(conn, :show, a)

    experience = Repo.get_by(Experience, attrs |> Map.drop([:activity_id, :category_id]))
      |> Repo.preload([:activity, :categories])
      
    assert experience
    assert Enum.find(experience.categories, fn(cat) -> cat.id == c.id end)
    assert experience.activity.id == a.id
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, activity: a} do
    conn = post conn, admin_activity_experience_path(conn, :create, a), experience: @invalid_attrs
    assert html_response(conn, 200) =~ "New Experience"
  end

  test "renders form for editing chosen resource", %{conn: conn, experience: e} do
    conn = get conn, admin_activity_experience_path(conn, :edit, e.activity, e)
    assert html_response(conn, 200) =~ "Edit Experience"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, experience: e} do
    e = e |> Repo.preload([:activity, :categories])
    assert length(e.categories) == 1

    conn = put conn, admin_activity_experience_path(conn, :update, e.activity, e), experience: @valid_attrs
    assert redirected_to(conn) == admin_activity_path(conn, :show, e.activity)
    assert Repo.get_by(Experience, @valid_attrs |> Map.drop([:activity_id, :category_id]))
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, activity: a} do
    experience = Repo.insert! %Experience{}
    conn = put conn, admin_activity_experience_path(conn, :update, a, experience), experience: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Experience"
  end

  test "deletes chosen resource", %{conn: conn, experience: e} do
    a = e.activity
    conn = delete conn, admin_activity_experience_path(conn, :delete, a, e)
    assert redirected_to(conn) == admin_activity_path(conn, :show, a)
    refute Repo.get(Experience, e.id)
  end
end
