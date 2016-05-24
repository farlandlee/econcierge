defmodule Grid.Admin.KioskController do
  use Grid.Web, :controller

  import Ecto.Query
  import Grid.Models.ManyToMany

  alias Grid.Kiosk
  alias Grid.Plugs

  plug Plugs.PageTitle, title: "Kiosk"
  plug :scrub_params, "kiosk" when action in [:create, :update]

  @assign_model_actions [:show, :edit, :update, :delete]
  plug :assign_vendors when action in [:create, :new, :update, :edit]
  plug Plugs.AssignModel, Kiosk when action in @assign_model_actions
  plug :preload_assocs when action in [:show, :edit, :update]

  plug Plugs.Breadcrumb, index: Kiosk
  plug Plugs.Breadcrumb, [show: Kiosk] when action in [:show, :edit]

  def index(conn, _) do
    kiosks = Repo.all(Kiosk)
    render(conn, "index.html", kiosks: kiosks)
  end

  def new(conn, _) do
    changeset = Kiosk.changeset(%Kiosk{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"kiosk" => kiosk_params}) do
    changeset = Kiosk.changeset(%Kiosk{}, kiosk_params)

    case Repo.insert(changeset) do
      {:ok, kiosk} ->
        manage_associated(kiosk, :kiosk_sponsors, :vendor_id, kiosk_params["vendor_id"])

        conn
        |> put_flash(:info, "Kiosk created successfully.")
        |> redirect(to: admin_kiosk_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _) do
    kiosk = conn.assigns.kiosk |> Repo.preload(:slides)
    render(conn, "show.html", kiosk: kiosk)
  end

  def edit(conn, _) do
    kiosk = conn.assigns.kiosk
    changeset = Kiosk.changeset(kiosk)
    render(conn, "edit.html", kiosk: kiosk, changeset: changeset)
  end

  def update(conn, %{"kiosk" => kiosk_params}) do
    kiosk = conn.assigns.kiosk
    changeset = Kiosk.changeset(kiosk, kiosk_params)

    case Repo.update(changeset) do
      {:ok, kiosk} ->
        manage_associated(kiosk, :kiosk_sponsors, :vendor_id, kiosk_params["vendor_id"])

        conn
        |> put_flash(:info, "Kiosk updated successfully.")
        |> redirect(to: admin_kiosk_path(conn, :show, kiosk))
      {:error, changeset} ->
        render(conn, "edit.html", kiosk: kiosk, changeset: changeset)
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.kiosk)

    conn
    |> put_flash(:info, "Kiosk deleted successfully.")
    |> redirect(to: admin_kiosk_path(conn, :index))
  end

  ## Plugs

  def assign_vendors(conn, _) do
    vendors = Grid.Vendor
      |> order_by(:name)
      |> Repo.all()

    assign(conn, :vendors, vendors)
  end

  def preload_assocs(conn, _) do
    kiosk = conn.assigns.kiosk
      |> Repo.preload([:vendors])

    assign(conn, :kiosk, kiosk)
  end
end
