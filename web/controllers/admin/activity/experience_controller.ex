defmodule Grid.Admin.Activity.ExperienceController do
  use Grid.Web, :controller

  alias Grid.Experience
  alias Grid.Activity
  alias Grid.Category

  import Ecto.Query

  plug Grid.Plugs.PageTitle, title: "Experience"
  plug Grid.Plugs.Breadcrumb, index: Experience
  plug :scrub_params, "experience" when action in [:create, :update]

  def new(conn, _params) do
    changeset = Experience.changeset(%Experience{})
    conn
    |> assign_form_selection_models
    |> render("new.html", changeset: changeset)
  end

  def create(conn, %{"experience" => experience_params}) do
    activity = conn.assigns.activity
    experience_params = Map.put(experience_params, "activity_id", activity.id)
    changeset = Experience.changeset(%Experience{}, experience_params)

    {:ok, conn} = Repo.transaction(fn ->
      case Repo.insert(changeset) do
        {:ok, experience} ->
          manage_associated(experience, :experience_categories, :category_id, experience_params["category_id"])

          conn
          |> put_flash(:info, "Experience created successfully.")
          |> redirect(to: admin_activity_path(conn, :show, activity))
        {:error, changeset} ->
          conn
          |> assign_form_selection_models
          |> render("new.html", changeset: changeset)
      end
    end)

    conn
  end

  def show(conn, %{"id" => id}) do
    experience = get_experience_with_assocs(id)
    products = experience
      |> assoc(:products)
      |> Repo.alphabetical
      |> preload(:vendor)
      |> Repo.all
    render(conn, "show.html",
      products: products,
      experience: experience,
      page_title: experience.name
    )
  end

  def edit(conn, %{"id" => id}) do
    experience = get_experience_with_assocs(id)
    changeset = Experience.changeset(experience)

    conn
    |> assign_form_selection_models
    |> render("edit.html", changeset: changeset, experience: experience)
  end

  def update(conn, %{"id" => id, "experience" => experience_params}) do
    experience = get_experience_with_assocs(id)
    changeset = Experience.changeset(experience, experience_params)

    {_, conn} = Repo.transaction(fn ->
      case Repo.update(changeset) do
        {:ok, experience} ->
          manage_associated(experience, :experience_categories, :category_id, experience_params["category_id"])

          conn
          |> put_flash(:info, "Experience updated successfully.")
          |> redirect(to: admin_activity_path(conn, :show, experience.activity))
        {:error, changeset} ->
          conn
          |> assign_form_selection_models
          |> render("edit.html", changeset: changeset, experience: experience)
      end
    end)

    conn
  end

  def delete(conn, %{"id" => id}) do
    experience = Repo.get!(Experience, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(experience)

    conn
    |> put_flash(:info, "Experience deleted successfully.")
    |> redirect(to: admin_activity_path(conn, :show, experience.activity_id))
  end

  #########
  # Helpers
  #########

  defp manage_associated(experience, relation, key, nil), do:
    manage_associated(experience, relation, key, [])

  defp manage_associated(experience, relation, key, ids) do
    Repo.delete_all(assoc(experience, relation))

    for s_id <- ids, {id, ""} = Integer.parse(s_id) do
      build_assoc(experience, relation, Map.put(%{}, key, id))
      |> Repo.insert!
    end
  end

  defp assign_form_selection_models(conn) do
    conn
    |> assign(:images, conn.assigns.activity |> assoc(:images) |> Repo.all())
    |> assign(:categories, Category |> order_by(:name) |> Repo.all())
  end

  defp get_experience_with_assocs(id) do
    Repo.get!(Experience, id) |> Repo.preload([:activity, :categories, :image])
  end
end
