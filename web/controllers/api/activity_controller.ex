defmodule Grid.Api.ActivityController do
  use Grid.Web, :controller

  alias Grid.Activity

  def index(conn, _) do
    activities = Activity.having_published_products
      |> Repo.all
      |> Repo.preload(:default_image)
    render(conn, "index.json", activities: activities)
  end

  def show(conn, %{"id" => id}) do
    activity = Repo.get!(Activity , id)
      |> Repo.preload(:default_image)
    render(conn, "show.json", activity: activity)
  end
end
