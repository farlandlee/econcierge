defmodule Grid.Admin.VendorController do
  use Grid.Web, :controller
  plug Grid.Plugs.PageTitle, title: "Vendor"

  import Ecto.Query

  alias Grid.Vendor
  alias Grid.Activity
  alias Grid.VendorActivity

  plug :scrub_params, "vendor" when action in [:create, :update]
  plug Grid.Plugs.AssignModel, Vendor when action in [:show, :edit, :update, :delete]
  plug :load_assocs when action in [:show, :edit, :update, :delete]

  def index(conn, _params) do
    vendors = Vendor |> order_by([v], [v.name]) |> Repo.all
    render(conn, "index.html", vendors: vendors)
  end

  def new(conn, _params) do
    changeset = Vendor.changeset(%Vendor{activities: []})
    render(conn, "new.html", changeset: changeset, activities: all_activities)
  end

  def create(conn, %{"vendor" => vendor_params}) do
    {:ok, conn} = Repo.transaction fn ->
      changeset = Vendor.changeset(%Vendor{}, vendor_params)

      case Repo.insert(changeset) do
        {:ok, vendor} ->
          insert_relationships(vendor, vendor_params["activities"])
          conn
          |> put_flash(:info, "Vendor created successfully.")
          |> redirect(to: admin_vendor_path(conn, :index))
        {:error, changeset} ->
          render(conn, "new.html", changeset: changeset, activities: all_activities)
      end
    end
    conn
  end

  def show(conn, _) do
    vendor = Repo.preload(conn.assigns.vendor, [:images, products: [:experience]])
    render(conn, "show.html", vendor: vendor, page_title: vendor.name)
  end

  def edit(conn, _) do
    vendor = conn.assigns.vendor
    changeset = Vendor.changeset(vendor)
    render(conn, "edit.html", vendor: vendor, changeset: changeset, activities: all_activities)
  end

  def update(conn, %{"vendor" => vendor_params}) do
    vendor = conn.assigns.vendor
    changeset = Vendor.changeset(vendor, vendor_params)
    {:ok, conn} = Repo.transaction fn ->
      case Repo.update(changeset) do
        {:ok, vendor} ->
          #clear out old relationships
          Repo.delete_all(from x in VendorActivity, where: x.vendor_id == ^vendor.id)
          #and insert the new ones
          insert_relationships(vendor, vendor_params["activities"])
          conn
          |> put_flash(:info, "Vendor updated successfully.")
          |> redirect(to: admin_vendor_path(conn, :show, vendor))
        {:error, changeset} ->
          render(conn, "edit.html", vendor: vendor, changeset: changeset, activities: all_activities)
      end
    end
    conn
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.vendor)

    conn
    |> put_flash(:info, "Vendor deleted successfully.")
    |> redirect(to: admin_vendor_path(conn, :index))
  end

  #############
  ##  Plugs  ##
  #############

  def load_assocs(conn, _) do
    vendor = conn.assigns.vendor |> Repo.preload([:activities, :default_image])
    assign(conn, :vendor, vendor)
  end

  #############
  ## Helpers ##
  #############

  defp all_activities do
    Repo.all(Activity)
  end

  defp insert_relationships(_, nil), do: :ok
  defp insert_relationships(vendor, activity_ids) do
    # create relationships
    for string_id <- activity_ids, {activity_id, ""} = Integer.parse(string_id) do
      Repo.insert!(%VendorActivity{vendor_id: vendor.id, activity_id: activity_id})
    end
  end
end
