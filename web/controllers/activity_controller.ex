defmodule Grid.ActivityController do
  use Grid.Web, :controller

  alias Grid.Activity
  alias Grid.Category

  plug Grid.Plugs.AssignAvailableActivities
  plug :activity_assigns when action in [
    :categories_by_activity_slug
  ]

  def show(conn, %{"activity" => %{"id" => ""}}), do: redirect(conn, to: page_path(conn, :index))
  def show(conn, %{"activity" => %{"id" => id}}) do
    activity_slug = Repo.one!(from a in Activity, where: a.id == ^id, select: a.slug)
    redirect(conn, to: activity_path(conn, :categories_by_activity_slug, activity_slug))
  end

  def index(conn, _) do
    activities = conn.assigns.available_activities |> Repo.preload(:default_image)
    render(conn, "index.html", available_activities: activities)
  end

  def categories_by_activity_slug(conn, _) do
    case length(conn.assigns.categories) do
      0 -> raise Ecto.NoResultsError
      1 ->
        category = hd(conn.assigns.categories)
        redirect(conn, to: explore_path(conn, :without_date, conn.assigns.activity.slug, category.slug))
      _ -> render(conn, "show.html")
    end
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
    |> Repo.preload(:image)

    conn
    |> assign(:activity, activity)
    |> assign(:categories, categories)
  end
end
