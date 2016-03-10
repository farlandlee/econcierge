defmodule Grid.Admin.Activity.CategoryController do
  use Grid.Web, :controller

  alias Grid.Category

  plug Grid.Plugs.PageTitle, title: "Category"
  plug :scrub_params, "category" when action in [:create, :update]
  plug :assign_form_selection_models when action in [:create, :new, :update, :edit]

  @assign_model_actions [:show, :edit, :update, :delete]
  plug Grid.Plugs.AssignModel, Category when action in @assign_model_actions

  plug Grid.Plugs.Breadcrumb, index: Category
  plug Grid.Plugs.Breadcrumb, [show: Category] when action == :edit

  def index(conn, _) do
    redirect_to_categories_tab(conn)
  end

  def show(conn, _) do
    redirect_to_categories_tab(conn)
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
        |> redirect_to_categories_tab
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, _) do
    category = conn.assigns.category
    changeset = Category.changeset(category)
    experiences = category
      |> assoc(:experiences)
      |> Repo.all()
    render(conn, "edit.html", changeset: changeset, experiences: experiences)
  end

  def update(conn, %{"category" => category_params}) do
    category = conn.assigns.category

    # Ensure that the category has this experience, else 404
    if eid = category_params["default_experience_id"] do
      _experience_category = Repo.get_by!(Grid.ExperienceCategory,
        experience_id: eid,
        category_id: category.id
      )
    end
    category
    |> Category.changeset(category_params)
    |> Repo.update()
    |> case do
      {:ok, _category} ->
        conn
        |> put_flash(:info, "Category updated successfully.")
        |> redirect_to_categories_tab
      {:error, changeset} ->
        experiences = category
          |> assoc(:experiences)
          |> Repo.all()

        conn
        |> put_flash(:error, "There was an error updating this category")
        |> render("edit.html", changeset: changeset, experiences: experiences)
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.category)

    conn
    |> put_flash(:info, "Category deleted successfully.")
    |> redirect_to_categories_tab
  end

  ###########
  ## Plugs ##
  ###########

  def assign_form_selection_models(conn, _) do
    images = conn.assigns.activity
      |> assoc(:images)
      |> Repo.all()

    assign(conn, :images, images)
  end

  #############
  ## Helpers ##
  #############

  defp redirect_to_categories_tab(conn) do
    redirect(conn, to: admin_activity_path(conn, :show, conn.assigns.activity, tab: "categories"))
  end
end
