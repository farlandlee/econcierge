defmodule Grid.Api.ActivityController do
  use Grid.Web, :controller

  alias Grid.Activity

  def index(conn, _) do
    activities = Activity.having_published_products
      |> Repo.all
      |> Repo.preload(:default_image)
    render(conn, "index.json", activities: activities)
  end

  def show(conn, %{"slug" => slug}) do
    activity = Activity 
      |> Repo.get_by!(slug: slug)
      |> Repo.preload(:default_image)
    render(conn, "show.json", activity: activity)
  end
end
