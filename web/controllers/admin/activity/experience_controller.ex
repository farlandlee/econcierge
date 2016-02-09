defmodule Grid.Admin.Activity.ExperienceController do
  use Grid.Web, :controller

  alias Grid.Experience
  alias Grid.Category

  import Ecto.Query

  plug Grid.Plugs.PageTitle, title: "Experience"
  plug :scrub_params, "experience" when action in [:create, :update]
  plug :assign_form_selection_models when action in [:create, :new, :update, :edit]

  plug Grid.Plugs.AssignModel, Experience when action in [:show, :edit, :update, :delete]
  plug :preload_assocs when action in [:show, :edit, :update]

  plug Grid.Plugs.Breadcrumb, index: Experience
  plug Grid.Plugs.Breadcrumb, [show: Experience] when action in [:show, :edit]


  def index(conn, _), do: redirect_to_experiences_tab(conn)

  def new(conn, _params) do
    changeset = Experience.changeset(%Experience{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"experience" => experience_params}) do
    changeset = experience_params
      |> Experience.creation_changeset(conn.assigns.activity.id)

    {:ok, conn} = Repo.transaction(fn ->
      case Repo.insert(changeset) do
        {:ok, experience} ->
          manage_associated(experience, :experience_categories, :category_id, experience_params["category_id"])

          conn
          |> put_flash(:info, "Experience created successfully.")
          |> redirect_to_experiences_tab
        {:error, changeset} ->
          render(conn, "new.html", changeset: changeset)
      end
    end)

    conn
  end

  def show(conn, _) do
    experience = conn.assigns.experience

    products = experience
      |> assoc(:products)
      |> Repo.alphabetical
      |> preload([:vendor, :activity, :meeting_location])
      |> Repo.all

    render(conn, "show.html", products: products, page_title: experience.name)
  end

  def edit(conn, _) do
    changeset = Experience.changeset(conn.assigns.experience)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"experience" => experience_params}) do
    changeset = conn.assigns.experience
      |> Experience.changeset(experience_params)

    {_, conn} = Repo.transaction(fn ->
      case Repo.update(changeset) do
        {:ok, experience} ->
          manage_associated(experience, :experience_categories, :category_id, experience_params["category_id"])

          conn
          |> put_flash(:info, "Experience updated successfully.")
          |> redirect_to_experiences_tab
        {:error, changeset} ->
          render(conn, "edit.html", changeset: changeset)
      end
    end)

    conn
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.experience)

    conn
    |> put_flash(:info, "Experience deleted successfully.")
    |> redirect_to_experiences_tab
  end

  #########
  # Helpers
  #########

  defp redirect_to_experiences_tab(conn) do
    redirect(conn,
      to: admin_activity_path(conn, :show, conn.assigns.activity,
        tab: "experiences"
    ))
  end

  defp manage_associated(experience, relation, key, nil), do:
    manage_associated(experience, relation, key, [])

  defp manage_associated(experience, relation, key, ids) do
    Repo.delete_all(assoc(experience, relation))

    for s_id <- ids, {id, ""} = Integer.parse(s_id) do
      build_assoc(experience, relation, Map.put(%{}, key, id))
      |> Repo.insert!
    end
  end


  ###########
  ## Plugs ##
  ###########

  def assign_form_selection_models(conn, _) do
    conn
    |> assign(:images, conn.assigns.activity |> assoc(:images) |> Repo.all())
    |> assign(:categories, Category |> order_by(:name) |> Repo.all())
  end

  def preload_assocs(conn, _) do
    exp = conn.assigns.experience
      |> Repo.preload([:activity, :categories, :image])
    assign(conn, :experience, exp)
  end
end
