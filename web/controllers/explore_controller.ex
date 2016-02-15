defmodule Grid.ExploreController do
  use Grid.Web, :controller

  import Ecto.Query

  alias Grid.{
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
    experience_ids = Category
      |> Repo.get_by(slug: category_slug)
      |> assoc(:experiences)
      |> select([e], e.id)
      |> Repo.all

    current = :erlang.date()

    season = from(
      s in Season,
        join: p in assoc(s, :products),
        where: p.experience_id in ^experience_ids,
        where: p.published == true
    ) |> Season.first_after_date(current) |> Repo.one!

    date = season.start_date |> Ecto.Date.to_string

    redirect conn, to: explore_path(conn, :index, activity_slug, category_slug, date, [])
  end
end
