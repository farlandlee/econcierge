defmodule Grid.Admin.Vendor.Product.StartTimeController do
  use Grid.Web, :controller

  alias Grid.StartTime

  plug :scrub_params, "start_time" when action == :create
  plug Grid.Plugs.AssignModel, StartTime when action == :delete

  def create(conn, %{"start_time" => start_time_params}) do
    product = conn.assigns.product
    changeset = StartTime.creation_changeset(start_time_params, product.id)

    redirect_path = admin_vendor_product_path(conn, :show, conn.assigns.vendor, product)

    case Repo.insert(changeset) do
      {:ok, _start_time} ->
        redirect(conn, to: redirect_path)
      {:error, _} ->
        conn
        |> put_flash(:error, "Error creating start time.")
        |> redirect(to: redirect_path)
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.start_time)
    redirect(conn, to: admin_vendor_product_path(conn, :show, conn.assigns.vendor, conn.assigns.product))
  end
end
