defmodule Grid.Admin.VendorController do
  use Grid.Web, :controller
  plug Grid.PageTitle, title: "Vendor"

  require Logger
  alias Grid.Vendor
  alias Grid.Activity
  alias Grid.VendorActivity
  alias Grid.Image

  plug :scrub_params, "vendor" when action in [:create, :update]

  defp all_activities do
    Repo.all(Activity)
  end

  defp load_with_relationships(id) do
    Repo.one!(
      from v in Vendor,
        where: v.id == ^id,
        preload: [:activities, :default_image]
    )
  end

  defp insert_relationships(_, nil), do: :ok
  defp insert_relationships(vendor, activity_ids) do
    # create relationships
    for string_id <- activity_ids, {activity_id, ""} = Integer.parse(string_id) do
      Repo.insert!(%VendorActivity{vendor_id: vendor.id, activity_id: activity_id})
    end
  end
  
  def index(conn, _params) do
    vendors = Repo.all(Vendor)
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

  def show(conn, %{"id" => id}) do
    vendor = load_with_relationships(id)
    render(conn, "show.html", vendor: vendor)
  end

  def edit(conn, %{"id" => id}) do
    vendor = load_with_relationships(id)
    changeset = Vendor.changeset(vendor)
    render(conn, "edit.html", vendor: vendor, changeset: changeset, activities: all_activities)
  end

  def update(conn, %{"id" => id, "vendor" => vendor_params}) do
    vendor = load_with_relationships(id)
    changeset = Vendor.changeset(vendor, vendor_params)
    {:ok, conn} = Repo.transaction fn ->
      case Repo.update(changeset) do
        {:ok, vendor} ->
          #clear out old relationships
          Repo.delete_all(from x in VendorActivity, where: x.vendor_id == ^id)
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

  def delete(conn, %{"id" => id}) do
    vendor = Repo.get!(Vendor, id)

    Repo.delete!(vendor)

    conn
    |> put_flash(:info, "Vendor deleted successfully.")
    |> redirect(to: admin_vendor_path(conn, :index))
  end
end
