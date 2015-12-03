defmodule Grid.Admin.VendorController do
  use Grid.Web, :controller

  alias Grid.Vendor

  plug :scrub_params, "vendor" when action in [:create, :update]

  def index(conn, _params) do
    vendors = Repo.all(Vendor)
    render(conn, "index.html", vendors: vendors)
  end

  def new(conn, _params) do
    changeset = Vendor.changeset(%Vendor{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"vendor" => vendor_params}) do
    changeset = Vendor.changeset(%Vendor{}, vendor_params)

    case Repo.insert(changeset) do
      {:ok, _vendor} ->
        conn
        |> put_flash(:info, "Vendor created successfully.")
        |> redirect(to: vendor_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    vendor = Repo.get!(Vendor, id)
    render(conn, "show.html", vendor: vendor)
  end

  def edit(conn, %{"id" => id}) do
    vendor = Repo.get!(Vendor, id)
    changeset = Vendor.changeset(vendor)
    render(conn, "edit.html", vendor: vendor, changeset: changeset)
  end

  def update(conn, %{"id" => id, "vendor" => vendor_params}) do
    vendor = Repo.get!(Vendor, id)
    changeset = Vendor.changeset(vendor, vendor_params)

    case Repo.update(changeset) do
      {:ok, vendor} ->
        conn
        |> put_flash(:info, "Vendor updated successfully.")
        |> redirect(to: vendor_path(conn, :show, vendor))
      {:error, changeset} ->
        render(conn, "edit.html", vendor: vendor, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    vendor = Repo.get!(Vendor, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(vendor)

    conn
    |> put_flash(:info, "Vendor deleted successfully.")
    |> redirect(to: vendor_path(conn, :index))
  end
end
