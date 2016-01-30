defmodule Grid.Admin.Vendor.VendorActivityController do
  use Grid.Web, :controller

  alias Grid.Plugs
  alias Grid.VendorActivity

  plug Plugs.PageTitle, title: "Activity"
  plug :scrub_params, "vendor_activity" when action in [:create, :update]

  plug Plugs.Breadcrumb, index: Grid.VendorActivity
  plug Plugs.AssignModel, [model: VendorActivity, preload: :activity]
    when action in [:show, :delete]
  plug Plugs.Breadcrumb, [show: Grid.VendorActivity]
    when action in [:show]

  def index(conn, _), do: redirect_to_vendor_activities(conn)
  def show(conn, _),  do: redirect_to_vendor_activities(conn)

  def create(conn, %{"vendor_activity" => activity_params}) do
    vendor = conn.assigns.vendor
    changeset = VendorActivity.creation_changeset(activity_params, vendor.id)

    case Repo.insert(changeset) do
      {:ok, _va} ->
        conn
        |> put_flash(:info, "Activity assigned successfully.")
        |> redirect_to_vendor_activities
      {:error, _changeset} -> # empty form submission, ignore
        redirect_to_vendor_activities(conn)
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.vendor_activity)
    conn
    |> put_flash(:info, "Activity deleted successfully.")
    |> redirect_to_vendor_activities
  end


  ###############
  ##  Helpers  ##
  ###############

  defp redirect_to_vendor_activities(conn) do
    redirect(conn, to: admin_vendor_path(conn, :show, conn.assigns.vendor, tab: "activities"))
  end
end
