defmodule Grid.PageController do
  use Grid.Web, :controller

  alias Grid.Activity
  alias Grid.Vendor

  def index(conn, _params) do
    activities = Repo.all(Activity)
    render(conn, "index.html", activities: activities)
  end

  def activity(conn, %{"activity" => %{"id" => id}}) do
    activities = Repo.all(Activity)
    selected_activity = Repo.one!(from a in Activity, where: a.id == ^id, preload: :vendors)
    render(conn, "activity.html", selected_activity: selected_activity, activities: activities)
  end

  def activity(conn, _) do
    redirect(conn, to: page_path(conn, :index))
  end
end
