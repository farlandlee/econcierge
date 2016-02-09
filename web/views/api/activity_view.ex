defmodule Grid.API.ActivityView do
  use Grid.Web, :view

  def render("index.json", %{activities: activities}) do
    %{activities: render_many(activities, __MODULE__, "activity.json")}
  end

  def render("show.json", %{activity: activity}) do
    %{activity: render_one(activity, __MODULE__, "activity.json")}
  end

  def render("activity.json", %{activity: activity}) do
    %{
      id: activity.id,
      name: activity.name,
      description: activity.description,
      slug: activity.slug
    }
  end
end
