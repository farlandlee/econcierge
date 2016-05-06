defmodule Grid.Api.ActivityController do
  use Grid.Web, :controller

  alias Grid.Activity

  def index(conn, params) do
    activities = Activity.having_published_products
      |> Repo.all_in_ids(params["ids"])
      |> preload
    render(conn, "index.json", activities: activities)
  end

  def show(conn, %{"id" => id}) do
    activity = Repo.get!(Activity , id)
      |> preload
    render(conn, "show.json", activity: activity)
  end

  def preload(activities) do
    Repo.preload(activities, [
      :default_image,
      amenities: :amenity_options
    ])
  end
end
