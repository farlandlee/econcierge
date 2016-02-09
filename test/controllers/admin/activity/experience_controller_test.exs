defmodule Grid.Admin.Activity.ExperienceControllerTest do
  use Grid.ConnCase

  alias Grid.Experience
  @valid_attrs %{
    name: "Some Name",
    description: "Some Description"
  }

  @invalid_attrs %{name: nil}

  setup do
    e = %{activity: a} = Factory.create(:experience)
    c = Factory.create(:category, activity: a)
    Factory.create(:experience_category, experience: e, category: c)

    {:ok, experience: e, activity: a}
  end

  test "index redirects to activities experience tab", %{conn: conn, activity: a} do
    conn = get conn, admin_activity_experience_path(conn, :index, a)
    assert redirected_to(conn, 302) == admin_activity_path(conn, :show, a, tab: "experiences")
  end

  test "renders form for new resources", %{conn: conn, activity: a} do
    conn = get conn, admin_activity_experience_path(conn, :new, a)
    assert html_response(conn, 200) =~ "New Experience"
  end

  test "creates resource and redirects when data is valid", %{conn: conn, activity: a} do
    c = Factory.create(:category)
    attrs = Map.put(@valid_attrs, :category_id, ["#{c.id}"])

    conn = post conn, admin_activity_experience_path(conn, :create, a), experience: attrs

    assert redirected_to(conn) == admin_activity_path(conn, :show, a, tab: "experiences")
    experience = Repo.get_by(Experience, attrs |> Map.drop([:activity_id, :category_id]))
      |> Repo.preload([:activity, :categories])

    assert experience
    assert Enum.find(experience.categories, fn(cat) -> cat.id == c.id end)
    assert experience.activity.id == a.id
  end

  test "Shows experience", %{conn: conn, experience: exp} do
    conn = get conn, admin_activity_experience_path(conn, :show, exp.activity, exp)
    resp = html_response(conn, 200)

    assert resp =~ "#{exp.name}"
    assert resp =~ "#{exp.description}"
    assert resp =~ "Slug"
    assert resp =~ "#{exp.slug}"
    assert resp =~ "Categories"
    assert resp =~ "Image"
  end

  test "Shows products", %{conn: conn} do
    product = %{experience: exp} = Factory.create(:product)

    conn = get conn, admin_activity_experience_path(conn, :show, exp.activity, exp)
    resp = html_response(conn, 200)
    assert resp =~ "Products"
    assert resp =~ "#{product.name}"
    assert resp =~ "#{product.vendor.name}"
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
    assert redirected_to(conn) == admin_activity_path(conn, :show, e.activity, tab: "experiences")
    assert Repo.get_by(Experience, @valid_attrs |> Map.drop([:activity_id, :category_id]))
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, activity: a, experience: e} do
    conn = put conn, admin_activity_experience_path(conn, :update, a, e), experience: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Experience"
  end

  test "deletes chosen resource", %{conn: conn, experience: e} do
    a = e.activity
    conn = delete conn, admin_activity_experience_path(conn, :delete, a, e)
    assert redirected_to(conn) == admin_activity_path(conn, :show, a, tab: "experiences")
    refute Repo.get(Experience, e.id)
  end
end
