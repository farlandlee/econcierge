defmodule Grid.Admin.Vendor.VendorActivity.SeasonController do
  use Grid.Web, :controller

  import Ecto.Query

  alias Grid.Plugs
  alias Grid.Season

  plug Plugs.PageTitle, title: "Season"
  plug :scrub_params, "season" when action in [:create, :update]
  plug Plugs.Breadcrumb, index: Season

  plug :assign_vendor_activities when action in [:new, :edit, :create, :update]
  @assign_model_actions [:show, :edit, :update, :delete]
  plug Plugs.AssignModel, Season when action in @assign_model_actions
  plug Plugs.Breadcrumb, [show: Season] when action in [:show, :edit]

  def index(conn, _), do: redirect_to_seasons(conn)
  def show(conn, _),  do: redirect_to_seasons(conn)

  def new(conn, _) do
    changeset = Season.changeset(%Season{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"season" => season_params}) do
    vendor_activity = conn.assigns.vendor_activity
    changeset = Season.creation_changeset(season_params, vendor_activity_id: vendor_activity.id)

    case Repo.insert(changeset) do
      {:ok, _season} ->
        conn
        |> put_flash(:info, "Season created successfully.")
        |> redirect_to_seasons
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, _) do
    season = conn.assigns.season
    changeset = Season.changeset(season)
    render(conn, "edit.html", season: season, changeset: changeset)
  end

  def update(conn, %{"season" => season_params}) do
    season = conn.assigns.season
    changeset = Season.changeset(season, season_params)

    case Repo.update(changeset) do
      {:ok, _season} ->
        conn
        |> put_flash(:info, "Season updated successfully.")
        |> redirect_to_seasons
      {:error, changeset} ->
        render(conn, "edit.html", season: season, changeset: changeset)
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.season)

    conn
    |> put_flash(:info, "Season deleted successfully.")
    |> redirect_to_seasons
  end

  ###############
  ##  Helpers  ##
  ###############

  defp redirect_to_seasons(conn) do
    redirect(conn, to: admin_vendor_vendor_activity_path(conn, :show,
      conn.assigns.vendor,
      conn.assigns.vendor_activity)
    )
  end

  ###############
  ##   Plugs   ##
  ###############

  defp assign_vendor_activities(conn, _) do
    vendor_activities = conn.assigns.vendor
      |> assoc(:vendor_activities)
      |> preload(:activity)
      |> Repo.all

    activities = Enum.map(vendor_activities, &(&1.activity))

    conn
    |> assign(:activities, activities)
    |> assign(:vendor_activities, vendor_activities)
  end
end
