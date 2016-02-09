defmodule Grid.ActivityController do
  use Grid.Web, :controller

  alias Grid.Activity
  alias Grid.Category

  plug Grid.Plugs.AssignAvailableActivities
  plug :activity_assigns when action in [
    :categories_by_activity_slug
  ]

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def show(conn, %{"activity" => %{"id" => ""}}), do: redirect(conn, to: page_path(conn, :index))
  def show(conn, %{"activity" => %{"id" => id}}) do
    activity_slug = Repo.one!(from a in Activity, where: a.id == ^id, select: a.slug)
    redirect(conn, to: activity_path(conn, :categories_by_activity_slug, activity_slug))
  end

  def categories_by_activity_slug(conn, _) do
   render(conn, "show.html")
  end

  def activity_assigns(conn, _) do
    slug = conn.params["activity_slug"]
    activity = Repo.get_by!(Activity, slug: slug)

    categories = from(c in Category,
      join: p in assoc(c, :products),
      join: a in assoc(p, :activity),
      where: a.id == ^activity.id,
      where: p.published == true,
      distinct: true)
    |> Repo.alphabetical
    |> Repo.all

    conn
    |> assign(:activity, activity)
    |> assign(:categories, categories)
  end
end
