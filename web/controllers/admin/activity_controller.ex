defmodule Grid.Admin.ActivityController do
  use Grid.Web, :controller

  alias Grid.Activity
  alias Grid.Plugs

  import Ecto.Query

  plug Plugs.PageTitle, title: "Activity"
  plug :scrub_params, "activity" when action in [:create, :update]
  plug Plugs.AssignModel, Activity when action in [:show, :edit]

  def index(conn, _params) do
    activity = Activity |> order_by(:name) |> Repo.all
    render(conn, "index.html", activity: activity)
  end

  def new(conn, _params) do
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
        :images,
        [experiences: [:categories, :image]]
      ])

    render(conn, "show.html", activity: activity, page_title: activity.name)
  end

  def edit(conn, _) do
    changeset = Activity.changeset(conn.assigns.activity)
    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"id" => id, "activity" => activity_params}) do
    activity = Repo.get!(Activity, id)

    changeset = Activity.changeset(activity, activity_params)

    case Repo.update(changeset) do
      {:ok, _activity} ->
        conn
        |> put_flash(:info, "Activity updated successfully.")
        |> redirect(to: admin_activity_path(conn, :show, activity))
      {:error, changeset} ->
        render(conn, "edit.html",
          activity: activity,
          changeset: changeset
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    activity = Repo.get!(Activity, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(activity)

    conn
    |> put_flash(:info, "Activity deleted successfully.")
    |> redirect(to: admin_activity_path(conn, :index))
  end
end
