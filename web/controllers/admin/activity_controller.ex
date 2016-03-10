defmodule Grid.Admin.ActivityController do
  use Grid.Web, :controller

  alias Grid.Activity
  alias Grid.Plugs

  plug Plugs.PageTitle, title: "Activity"
  plug Plugs.Breadcrumb, index: Activity
  plug :scrub_params, "activity" when action in [:create, :update]
  plug Plugs.AssignModel, Activity when action in [:update, :show, :edit, :delete]
  plug Plugs.Breadcrumb, [show: Activity] when action in [:show, :edit]

  def index(conn, _) do
    activities = Activity |> Repo.alphabetical |> Repo.all
    render(conn, "index.html", activities: activities)
  end

  def new(conn, _) do
    changeset = Activity.changeset(%Activity{categories: []})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"activity" => activity_params}) do
    changeset = Activity.changeset(%Activity{}, activity_params)

    case Repo.insert(changeset) do
      {:ok, _activity} ->
        conn
        |> put_flash(:info, "Activity created successfully.")
        |> redirect(to: admin_activity_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, _) do
    activity = conn.assigns.activity
      |> Repo.preload([
        :amenities,
        :images,
        categories: [:image, :default_experience],
        experiences: [:categories, :image]
      ])

    render(conn, "show.html", activity: activity, page_title: activity.name)
  end

  def edit(conn, _) do
    changeset = Activity.changeset(conn.assigns.activity)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"activity" => activity_params}) do
    changeset = Activity.changeset(conn.assigns.activity, activity_params)

    case Repo.update(changeset) do
      {:ok, activity} ->
        conn
        |> put_flash(:info, "Activity updated successfully.")
        |> redirect(to: admin_activity_path(conn, :show, activity))
      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, _) do
    Repo.delete!(conn.assigns.activity)

    conn
    |> put_flash(:info, "Activity deleted successfully.")
    |> redirect(to: admin_activity_path(conn, :index))
  end
end
