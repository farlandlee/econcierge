defmodule Grid.Admin.ActivityController do
  use Grid.Web, :controller
  plug Grid.Plugs.PageTitle, title: "Activity"

  alias Grid.Activity
  alias Grid.Category
  alias Grid.ActivityCategory

  import Ecto.Query

  plug :scrub_params, "activity" when action in [:create, :update]

  def index(conn, _params) do
    activity = Activity |> order_by([a], [a.name]) |> Repo.all
    render(conn, "index.html", activity: activity)
  end

  def new(conn, _params) do
    changeset = Activity.changeset(%Activity{categories: []})
    render(conn, "new.html",
      changeset: changeset,
      categories: get_ordered_categories
    )
  end

  def create(conn, %{"activity" => activity_params}) do
    changeset = Activity.changeset(%Activity{}, activity_params)

    {:ok, conn} = Repo.transaction fn ->
      case Repo.insert(changeset) do
        {:ok, activity} ->
          insert_categories(activity, activity_params["categories"])

          conn
          |> put_flash(:info, "Activity created successfully.")
          |> redirect(to: admin_activity_path(conn, :index))
        {:error, changeset} ->
          render(conn, "new.html",
            changeset: changeset,
            categories: get_ordered_categories
          )
      end
    end

    conn
  end

  def show(conn, %{"id" => id}) do
    activity = Repo.get!(Activity, id) |> Repo.preload(:categories)

    render(conn, "show.html", activity: activity)
  end

  def edit(conn, %{"id" => id}) do
    activity = Repo.get!(Activity, id) |> Repo.preload(:categories)

    changeset = Activity.changeset(activity)
    render(conn, "edit.html",
      activity: activity,
      changeset: changeset,
      categories: get_ordered_categories
    )
  end

  def update(conn, %{"id" => id, "activity" => activity_params}) do
    activity = Repo.get!(Activity, id) |> Repo.preload(:categories)

    changeset = Activity.changeset(activity, activity_params)

    {:ok, conn} = Repo.transaction fn ->
      case Repo.update(changeset) do
        {:ok, activity} ->
          # Update associated categories
          Repo.delete_all(from ac in ActivityCategory, where: ac.activity_id == ^id)
          insert_categories(activity, activity_params["categories"])

          conn
          |> put_flash(:info, "Activity updated successfully.")
          |> redirect(to: admin_activity_path(conn, :show, activity))
        {:error, changeset} ->
          render(conn, "edit.html",
            activity: activity,
            changeset: changeset,
            categories: get_ordered_categories
          )
      end
    end

    conn
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

  ##########
  # Helpers
  ##########

  defp insert_categories(_, nil), do: :ok
  defp insert_categories(activity, category_ids) do
    # create relationships
    for id <- category_ids, {category_id, ""} = Integer.parse(id) do
      Repo.insert!(%ActivityCategory{
        activity_id: activity.id,
        category_id: category_id
      })
    end
  end

  defp get_ordered_categories do
    Category |> order_by([c], [c.name]) |> Repo.all
  end
end
