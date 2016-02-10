defmodule Grid.Admin.Activity.CategoryController do
  use Grid.Web, :controller

  alias Grid.Category

  plug Grid.Plugs.PageTitle, title: "Category"
  plug :scrub_params, "category" when action in [:create, :update]
  plug :assign_form_selection_models when action in [:create, :new, :update, :edit]
  plug Grid.Plugs.Breadcrumb, index: Category
  plug Grid.Plugs.AssignModel, Category when action in [:show, :edit, :update, :delete]
  plug Grid.Plugs.Breadcrumb, [show: Category] when action == :edit

  def index(conn, _) do
    redirect(conn, to: admin_activity_path(conn, :show, conn.assigns.activity, tab: "categories"))
  end

  def show(conn, _) do
    redirect(conn, to: admin_activity_path(conn, :show, conn.assigns.activity, tab: "categories"))
  end

  def new(conn, _) do
    changeset = Category.changeset(%Category{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"category" => category_params}) do
    activity = conn.assigns.activity
    changeset = Category.creation_changeset(category_params, activity.id)

    case Repo.insert(changeset) do
      {:ok, _category} ->
        conn
        |> put_flash(:info, "Category created successfully.")
        |> redirect(to: admin_activity_path(conn, :show, activity, tab: "categories"))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, _) do
    changeset = Category.changeset(conn.assigns.category)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"category" => category_params}) do
    category = conn.assigns.category
    changeset = Category.changeset(category, category_params)

    case Repo.update(changeset) do
      {:ok, _category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect(to: admin_activity_path(conn, :show, conn.assigns.activity, tab: "categories"))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect(to: admin_activity_path(conn, :show, conn.assigns.activity, tab: "categories"))
  end

  ###########
  ## Plugs ##
  ###########

  def assign_form_selection_models(conn, _) do
    images = conn.assigns.activity
      |> assoc(:images)
      |> Repo.all()

    conn
    |> assign(:images, images)
  end
end
