defmodule Grid.ActivityController do
  use Grid.Web, :controller

  alias Grid.Activity

  def show(conn, %{"activity" => %{"id" => id}}) do
    activity_name = Repo.one!(from a in Activity, where: a.id == ^id, select: a.name)
    redirect(conn, to: activity_path(conn, :show_by_name, activity_name))
  end
  def show_by_name(conn, %{"activity_name" => activity_name}) do
    activities = Repo.all(Activity)
    activity = Repo.one!(from a in Activity, where: a.name == ^activity_name, preload: [vendors: :default_image])
    render(conn, "show.html", activity: activity, activities: activities)
  end
end
