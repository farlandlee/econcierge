defmodule Grid.Admin.Activity.CategoryControllerTest do
  use Grid.ConnCase

  alias Grid.Category
  @valid_attrs %{name: "some content", description: "some description"}
  @invalid_attrs %{name: nil, description: nil}

  setup do
    category = Factory.create(:category)
    activity = category.activity
    {:ok, category: category, activity: activity}
  end

  test "index redirects to activity show", %{conn: conn, activity: activity} do
    conn = get conn, admin_activity_category_path(conn, :index, activity)
    assert redirected_to(conn) == admin_activity_path(conn, :show, activity, tab: "categories")
  end

  test "show redirects to activity show", %{conn: conn, activity: activity, category: category} do
    conn = get conn, admin_activity_category_path(conn, :show, activity, category)
    assert redirected_to(conn) == admin_activity_path(conn, :show, activity, tab: "categories")
  end

  test "renders form for new resources", %{conn: conn, activity: activity} do
    conn = get conn, admin_activity_category_path(conn, :new, activity)

    response = html_response(conn, 200)
    assert response =~ "New Category"
    assert response =~ "Upload #{activity.name} images"
  end

  test "renders form for new resources with images", %{conn: conn, activity: activity} do
    image = Factory.create_activity_image(assoc_id: activity.id)
    conn = get conn, admin_activity_category_path(conn, :new, activity)

    response = html_response(conn, 200)
    assert response =~ "New Category"
    assert response =~ image.alt
  end

  test "creates resource and redirects when data is valid", %{conn: conn, activity: activity} do
    conn = post conn, admin_activity_category_path(conn, :create, activity), category: @valid_attrs
    assert redirected_to(conn) == admin_activity_path(conn, :show, activity, tab: "categories")
    assert Repo.get_by(Category, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, activity: activity} do
    conn = post conn, admin_activity_category_path(conn, :create, activity), category: @invalid_attrs
    assert html_response(conn, 200) =~ "New Category"
  end

  test "renders form for editing chosen resource", %{conn: conn, activity: activity, category: category} do
    conn = get conn, admin_activity_category_path(conn, :edit, activity, category)
    assert html_response(conn, 200) =~ "Edit Category"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn, activity: activity, category: category} do
    conn = put conn, admin_activity_category_path(conn, :update, activity, category), category: @valid_attrs
    assert redirected_to(conn) == admin_activity_path(conn, :show, activity, tab: "categories")
    assert Repo.get_by(Category, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, activity: activity, category: category} do
    conn = put conn, admin_activity_category_path(conn, :update, activity, category), category: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Category"
  end

  test "update 404s for invalid default experience ids", %{conn: conn, activity: activity, category: category} do
    assert_raise Ecto.NoResultsError, fn ->
      put conn, admin_activity_category_path(conn, :update, activity, category), category: %{default_experience_id: -1}
    end
  end

  test "deletes chosen resource", %{conn: conn, activity: activity, category: category} do
    conn = delete conn, admin_activity_category_path(conn, :delete, activity, category)
    assert redirected_to(conn) == admin_activity_path(conn, :show, activity, tab: "categories")
    refute Repo.get(Category, category.id)
  end
end
