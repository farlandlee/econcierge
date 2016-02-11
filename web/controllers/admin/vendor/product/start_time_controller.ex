defmodule Grid.Admin.Vendor.Product.StartTimeController do
  use Grid.Web, :controller

  alias Grid.Plugs
  alias Grid.StartTime

  plug Plugs.PageTitle, title: "Start Time"
  plug :scrub_params, "start_time" when action == :create

  plug Plugs.Breadcrumb, index: StartTime
  plug Plugs.AssignModel, StartTime when action in [:edit, :update, :delete]

  plug :assign_product_activity_seasons when action in [:new, :edit]


  def index(conn, _) do
    redirect(conn, to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, conn.assigns.product))
  end

  def show(conn, _) do
    redirect(conn, to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, conn.assigns.product))
  end

  def new(conn, _params) do
    %{activity: activity} = conn.assigns.product
      |> Repo.preload(:activity)
    changeset = StartTime.changeset(%StartTime{})
    render(conn, "new.html", changeset: changeset, activity: activity)
  end

  def create(conn, %{"start_time" => start_time_params}) do
    product = conn.assigns.product
    changeset = start_time_params
      |> StartTime.creation_changeset(product_id: product.id)

    case Repo.insert(changeset) do
      {:ok, _start_time} ->
        redirect(conn, to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, product))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error creating start time.")
        |> assign_product_activity_seasons
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, _) do
    changeset = StartTime.changeset(conn.assigns.start_time)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"start_time" => start_time_params}) do
    product = conn.assigns.product
    changeset = conn.assigns.start_time
      |> StartTime.changeset(start_time_params)

    case Repo.update(changeset) do
      {:ok, _start_time} ->
        redirect(conn, to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, product))
      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error creating start time.")
        |> assign_product_activity_seasons
        |> render("edit.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.start_time)
    redirect(conn, to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, conn.assigns.product))
  end

  #############
  ##  Plugs  ##
  #############

  def assign_product_activity_seasons(conn, _ \\ :ok) do
    product = conn.assigns.product

    seasons = from(s in Grid.Season,
      join: e in Grid.Experience,
        on: e.id == ^product.experience_id,
      join: va in Grid.VendorActivity,
        on: va.vendor_id == ^product.vendor_id
            and va.activity_id == e.activity_id
            and s.vendor_activity_id == va.id)
    |> Repo.all

    assign(conn,:seasons, seasons)
  end
end
