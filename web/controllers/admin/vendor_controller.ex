defmodule Grid.Admin.VendorController do
  use Grid.Web, :controller

  import Ecto.Query

  alias Grid.Activity
  alias Grid.Plugs
  alias Grid.Vendor
  alias Grid.VendorActivity

  plug Plugs.PageTitle, title: "Vendor"
  plug :scrub_params, "vendor" when action in [:create, :update]
  plug Plugs.Breadcrumb, index: Vendor

  @assign_model_actions [:show, :edit, :update, :delete]
  plug Plugs.AssignModel, Vendor when action in @assign_model_actions
  plug Plugs.Breadcrumb, [show: Vendor] when action in [:show, :edit]

  def index(conn, params) do
    activity_id = params["activity_id"]
    vendors = Vendor
      |> Repo.alphabetical
      |> Vendor.with_activity(activity_id)
      |> preload(:activities)
      |> Repo.all

    # Get activity with number of vendors for that activity
    # To use in vendor filtering
    activities = from(a in Activity,
      join: va in VendorActivity,
        on: va.activity_id == a.id,
      group_by: a.id,
      select: %{name: a.name, id: a.id, vendor_count: count(va.vendor_id)})
      |> Repo.alphabetical
      |> Repo.all

    conn
    |> assign_activity_filter(activity_id)
    |> render("index.html", vendors: vendors, activities: activities)
  end

  def new(conn, _params) do
    changeset = Vendor.changeset(%Vendor{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"vendor" => vendor_params}) do
    changeset = Vendor.changeset(%Vendor{}, vendor_params)
    case Repo.insert(changeset) do
      {:ok, vendor} ->
        conn
        |> put_flash(:info, "Vendor created successfully.")
        |> redirect(to: admin_vendor_path(conn, :show, vendor))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _) do
    vendor = Repo.preload(conn.assigns.vendor, [
      :activities,
      :images,
      :locations,
      seasons: :activity,
      products: [:experience, :meeting_location]
    ])

    current_activity_ids = vendor.activities |> Enum.map(&(&1.id))

    addable_activities = where(Activity, [a], not(a.id in ^current_activity_ids))
      |> Repo.all

    render(conn, "show.html",
      page_title: vendor.name,
      vendor: vendor,
      addable_activities: addable_activities
    )
  end

  def edit(conn, _) do
    vendor = conn.assigns.vendor
    changeset = Vendor.changeset(vendor)
    render(conn, "edit.html", vendor: vendor, changeset: changeset)
  end

  def update(conn, %{"vendor" => vendor_params}) do
    vendor = conn.assigns.vendor
    changeset = Vendor.changeset(vendor, vendor_params)
    case Repo.update(changeset) do
      {:ok, vendor} ->
        conn
        |> put_flash(:info, "Vendor updated successfully.")
        |> redirect(to: admin_vendor_path(conn, :show, vendor))
      {:error, changeset} ->
        render(conn, "edit.html", vendor: vendor, changeset: changeset)
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.vendor)

    conn
    |> put_flash(:info, "Vendor deleted successfully.")
    |> redirect(to: admin_vendor_path(conn, :index))
  end

  #############
  ## Helpers ##
  #############

  def assign_activity_filter(conn, id) do
    assignment = case id do
      nil -> nil
      id -> Repo.get!(Activity, id)
    end
    assign(conn, :activity_filter, assignment)
  end
end
