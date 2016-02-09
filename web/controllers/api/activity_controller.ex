defmodule Grid.API.ActivityController do
  use Grid.Web, :controller

  alias Grid.Activity

  def index(conn, _) do
    activities = Repo.all(Activity)
    render(conn, "index.json", activities: activities)
  end

  def show(conn, %{"slug" => slug}) do
    activity = Activity |> Repo.get_by!(slug: slug)
    render(conn, "show.json", activity: activity)
  end
end