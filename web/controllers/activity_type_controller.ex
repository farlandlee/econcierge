defmodule Grid.ActivityTypeController do
  use Grid.Web, :controller

  alias Grid.ActivityType

  plug :scrub_params, "activity_type" when action in [:create, :update]

  def index(conn, _params) do
    activity_types = Repo.all(ActivityType)
    render(conn, "index.html", activity_types: activity_types)
  end

  def new(conn, _params) do
    changeset = ActivityType.changeset(%ActivityType{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"activity_type" => activity_type_params}) do
    changeset = ActivityType.changeset(%ActivityType{}, activity_type_params)

    case Repo.insert(changeset) do
      {:ok, _activity_type} ->
        conn
        |> put_flash(:info, "Activity type created successfully.")
        |> redirect(to: activity_type_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    activity_type = Repo.get!(ActivityType, id)
    render(conn, "show.html", activity_type: activity_type)
  end

  def edit(conn, %{"id" => id}) do
    activity_type = Repo.get!(ActivityType, id)
    changeset = ActivityType.changeset(activity_type)
    render(conn, "edit.html", activity_type: activity_type, changeset: changeset)
  end

  def update(conn, %{"id" => id, "activity_type" => activity_type_params}) do
    activity_type = Repo.get!(ActivityType, id)
    changeset = ActivityType.changeset(activity_type, activity_type_params)

    case Repo.update(changeset) do
      {:ok, activity_type} ->
        conn
        |> put_flash(:info, "Activity type updated successfully.")
        |> redirect(to: activity_type_path(conn, :show, activity_type))
      {:error, changeset} ->
        render(conn, "edit.html", activity_type: activity_type, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    activity_type = Repo.get!(ActivityType, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(activity_type)

    conn
    |> put_flash(:info, "Activity type deleted successfully.")
    |> redirect(to: activity_type_path(conn, :index))
  end
end
