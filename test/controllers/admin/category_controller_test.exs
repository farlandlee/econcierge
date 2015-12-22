defmodule Grid.Admin.CategoryControllerTest do
  use Grid.ConnCase

  alias Grid.Category
  @valid_attrs %{name: "some content", description: "some description"}
  @invalid_attrs %{}

  setup do
    conn = conn()
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, admin_category_path(conn, :index)
    assert html_response(conn, 200) =~ "Category Listing"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, admin_category_path(conn, :new)
    assert html_response(conn, 200) =~ "New Category"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, admin_category_path(conn, :create), category: @valid_attrs
    assert redirected_to(conn) == admin_category_path(conn, :index)
    assert Repo.get_by(Category, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, admin_category_path(conn, :create), category: @invalid_attrs
    assert html_response(conn, 200) =~ "New Category"
  end

  test "shows chosen resource", %{conn: conn} do
    category = Repo.insert! %Category{}
    conn = get conn, admin_category_path(conn, :show, category)
    assert html_response(conn, 200) =~ "Show Category"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, admin_category_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    category = Repo.insert! %Category{}
    conn = get conn, admin_category_path(conn, :edit, category)
    assert html_response(conn, 200) =~ "Edit Category"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    category = Repo.insert! %Category{}
    conn = put conn, admin_category_path(conn, :update, category), category: @valid_attrs
    assert redirected_to(conn) == admin_category_path(conn, :show, category)
    assert Repo.get_by(Category, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    category = Repo.insert! %Category{}
    conn = put conn, admin_category_path(conn, :update, category), category: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit Category"
  end

  test "deletes chosen resource", %{conn: conn} do
    category = Repo.insert! %Category{}
    conn = delete conn, admin_category_path(conn, :delete, category)
    assert redirected_to(conn) == admin_category_path(conn, :index)
    refute Repo.get(Category, category.id)
  end
end
