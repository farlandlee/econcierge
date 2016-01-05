defmodule Grid.Admin.Vendor.Product.StartTimeController do
  use Grid.Web, :controller

  alias Grid.StartTime

  import Ecto.Query

  plug Grid.Plugs.PageTitle, title: "Start Time"
  plug :scrub_params, "start_time" when action == :create
  plug Grid.Plugs.AssignModel, StartTime when action == :delete

  def index(conn, _) do
    product = conn.assigns.product
    changeset = StartTime.changeset(%StartTime{})
    render(conn, "index.html",
      start_times: start_times_for(product),
      changeset: changeset,
      page_title: "#{product.name} Start Times"
    )
  end

  def create(conn, %{"start_time" => start_time_params}) do
    product = conn.assigns.product

    changeset = StartTime.changeset(%StartTime{}, start_time_params)
      |> Ecto.Changeset.put_change(:product_id, conn.assigns.product.id)

    case Repo.insert(changeset) do
      {:ok, _start_time} ->
        conn
        |> put_flash(:info, "Start time created successfully.")
        |> redirect(to: admin_vendor_product_start_time_path(conn, :index, conn.assigns.vendor, product))
      {:error, changeset} ->
        start_times = Repo.all(StartTime)
        render(conn, "index.html",
          start_times: start_times_for(product),
          changeset: changeset,
          page_title: "#{product.name} Start Times"
        )
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.start_time)
    conn
    |> put_flash(:info, "Start time deleted successfully.")
    |> redirect(to: admin_vendor_product_start_time_path(conn, :index, conn.assigns.vendor, conn.assigns.product))
  end

  def start_times_for(product) do
    StartTime
    |> order_by(:starts_at_time)
    |> where(product_id: ^product.id)
    |> Repo.all
  end
end
