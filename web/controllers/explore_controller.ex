defmodule Grid.ExploreController do
  use Grid.Web, :controller

  import Ecto.Query

  alias Grid.{
    Activity,
    Category,
    Season
  }

  def index(conn, _) do
    conn
    |> put_layout(false)
    |> put_resp_header("content-type", "text/html")
    |> render
  end

  def without_date(conn, %{"activity_slug" => activity_slug, "category_slug" => category_slug}) do
    activity = Repo.get_by(Activity, slug: activity_slug)

    experience_ids = Category
      |> Repo.get_by(slug: category_slug, activity_id: activity.id)
      |> assoc(:experiences)
      |> select([e], e.id)
      |> Repo.all

    current = Ecto.Date.from_erl(:erlang.date())

    season = from(
      s in Season,
        join: p in assoc(s, :products),
        where: p.experience_id in ^experience_ids,
        where: p.published == true
    ) |> Season.first_from_date(current) |> Repo.one!

    date = case Ecto.Date.compare(current, season.start_date) do
      :lt -> season.start_date
      _ -> current
    end |> Ecto.Date.to_string

    redirect conn, to: explore_path(conn, :index, activity_slug, category_slug, date, [])
  end
end
