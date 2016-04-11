defmodule Grid.Admin.Activity.AmenityController do
  use Grid.Web, :controller

  alias Grid.Amenity
  alias Grid.Plugs

  plug Plugs.PageTitle, title: "Amenity"
  plug :scrub_params, "amenity" when action in [:create, :update]

  @assign_model_actions [:show, :edit, :update, :delete]
  plug Plugs.AssignModel, Amenity when action in @assign_model_actions

  plug Plugs.Breadcrumb, index: Amenity
  plug Plugs.Breadcrumb, [show: Amenity] when action in [:show, :edit]

  def index(conn, _) do
    redirect(conn, to: admin_activity_path(conn, :show, conn.assigns.activity, tab: "amenities"))
  end

  def new(conn, _) do
    changeset = Amenity.changeset(%Amenity{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"amenity" => amenity_params}) do
    activity = conn.assigns.activity
    changeset = Amenity.creation_changeset(amenity_params, activity.id)

    case Repo.insert(changeset) do
      {:ok, _amenity} ->
        conn
        |> put_flash(:info, "Amenity created successfully.")
        |> redirect_to_activity_show
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _) do
    amenity = conn.assigns.amenity |> Repo.preload(:amenity_options)
    render(conn, "show.html", amenity: amenity, page_title: amenity.name)
  end

  def edit(conn, _) do
    amenity = conn.assigns.amenity
    changeset = Amenity.changeset(amenity)
    render(conn, "edit.html", amenity: amenity, changeset: changeset)
  end

  def update(conn, %{"amenity" => amenity_params}) do
    amenity = conn.assigns.amenity
    changeset = Amenity.changeset(amenity, amenity_params)

    case Repo.update(changeset) do
      {:ok, _amenity} ->
        conn
        |> put_flash(:info, "Amenity updated successfully.")
        |> redirect_to_activity_show
      {:error, changeset} ->
        render(conn, "edit.html", amenity: amenity, changeset: changeset)
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.amenity)

    conn
    |> put_flash(:info, "Amenity deleted successfully.")
    |> redirect_to_activity_show
  end

  defp redirect_to_activity_show(conn) do
    redirect(conn, to: admin_activity_path(conn, :show, conn.assigns.activity))
  end
end
