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
    activity = Repo.get_by!(Activity, slug: activity_slug)
    category = Repo.get_by!(Category, activity_id: activity.id, slug: category_slug)

    experience_ids = assoc(category, :experiences)
      |> select([e], e.id)
      |> Repo.all

    today = Ecto.Date.from_erl(:erlang.date())

    season = Season.having_published_products()
      |> where([_s, p], p.experience_id in ^experience_ids)
      |> Season.first_from_date(today)
      |> Repo.one!

    date = case Ecto.Date.compare(today, season.start_date) do
      :lt -> season.start_date
      _ -> today
    end |> Ecto.Date.to_string

    redirect conn, to: explore_path(conn, :index, activity_slug, category_slug, date, [])
  end
end
