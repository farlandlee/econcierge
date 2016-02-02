defmodule Grid.Admin.Activity.Amenity.AmenityOptionController do
  use Grid.Web, :controller

  alias Grid.AmenityOption
  alias Grid.Plugs

  plug Plugs.PageTitle, title: "Amenity Option"
  plug :scrub_params, "amenity_option" when action in [:create, :update]

  @assign_model_actions [:show, :edit, :update, :delete]
  plug Plugs.AssignModel, AmenityOption when action in @assign_model_actions

  plug Plugs.Breadcrumb, index: AmenityOption
  plug Plugs.Breadcrumb, [show: AmenityOption] when action in [:edit]

  def index(conn, _) do
    redirect_to_amenity_show(conn)
  end

  def new(conn, _) do
    changeset = AmenityOption.changeset(%AmenityOption{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"amenity_option" => amenity_option_params}) do
    amenity = conn.assigns.amenity
    changeset = AmenityOption.creation_changeset(amenity_option_params, amenity.id)

    case Repo.insert(changeset) do
      {:ok, _amenity_option} ->
        conn
        |> put_flash(:info, "Amenity option created successfully.")
        |> redirect_to_amenity_show
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _) do
    redirect_to_amenity_show(conn)
  end

  def edit(conn, _) do
    amenity_option = conn.assigns.amenity_option
    changeset = AmenityOption.changeset(amenity_option)
    render(conn, "edit.html", amenity_option: amenity_option, changeset: changeset)
  end

  def update(conn, %{"amenity_option" => amenity_option_params}) do
    amenity_option = conn.assigns.amenity_option
    changeset = AmenityOption.changeset(amenity_option, amenity_option_params)

    case Repo.update(changeset) do
      {:ok, _amenity_option} ->
        conn
        |> put_flash(:info, "Amenity option updated successfully.")
        |> redirect_to_amenity_show
      {:error, changeset} ->
        render(conn, "edit.html", amenity_option: amenity_option, changeset: changeset)
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.amenity_option)

    conn
    |> put_flash(:info, "Amenity option deleted successfully.")
    |> redirect_to_amenity_show
  end

  defp redirect_to_amenity_show(conn) do
    redirect(conn, to: admin_activity_amenity_path(conn, :show, conn.assigns.activity, conn.assigns.amenity))
  end
end
