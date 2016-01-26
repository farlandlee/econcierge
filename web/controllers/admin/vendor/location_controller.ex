defmodule Grid.Admin.Vendor.LocationController do
  use Grid.Web, :controller

  alias Grid.Location
  alias Grid.Plugs

  plug Plugs.PageTitle, title: "Location"
  plug :scrub_params, "location" when action in [:create, :update]
  plug Plugs.Breadcrumb, index: Location
  @assign_model_actions [:show, :edit, :update, :delete]
  plug Plugs.AssignModel, Location when action in @assign_model_actions
  plug Plugs.Breadcrumb, [show: Location] when action == :edit

  def index(conn, _) do
    redirect(conn, to: admin_vendor_path(conn, :show, conn.assigns.vendor))
  end

  def show(conn, _) do
    redirect(conn, to: admin_vendor_path(conn, :show, conn.assigns.vendor))
  end

  def new(conn, _) do
    changeset = Location.changeset(%Location{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"location" => location_params}) do
    vendor = conn.assigns.vendor
    changeset = Location.creation_changeset(location_params, vendor.id)

    case Repo.insert(changeset) do
      {:ok, _location} ->
        conn
        |> put_flash(:info, "Location created successfully.")
        |> redirect(to: admin_vendor_location_path(conn, :index, conn.assigns.vendor))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, _) do
    changeset = Location.changeset(conn.assigns.location)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"location" => location_params}) do
    changeset = Location.changeset(conn.assigns.location, location_params)

    case Repo.update(changeset) do
      {:ok, _location} ->
        conn
        |> put_flash(:info, "Location updated successfully.")
        |> redirect(to: admin_vendor_path(conn, :show, conn.assigns.vendor))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.location)

    conn
    |> put_flash(:info, "Location deleted successfully.")
    |> redirect(to: admin_vendor_path(conn, :show, conn.assigns.vendor))
  end
end
