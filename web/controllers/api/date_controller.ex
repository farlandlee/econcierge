defmodule Grid.Api.DateController do
  use Grid.Web, :controller

  import Ecto.Query

  alias Grid.{
    Activity,
    Category,
    Season
  }

  def first_experience_date(conn, %{"activity_slug" => activity_slug, "category_slug" => category_slug}) do
    activity = Repo.get_by!(Activity, slug: activity_slug)
    category = Repo.get_by!(Category, activity_id: activity.id, slug: category_slug)

    experience_ids = assoc(category, :experiences)
      |> select([e], e.id)
      |> Repo.all

    tomorrow = Calendar.DateTime.now!("MST")
      |> Calendar.Date.advance!(1)
      |> Ecto.Date.cast!

    season = Season.having_published_products()
      |> where([_s, p], p.experience_id in ^experience_ids)
      |> Season.first_from_date(tomorrow)
      |> Repo.one!

    date = case Ecto.Date.compare(tomorrow, season.start_date) do
      :lt -> season.start_date
      _ -> tomorrow
    end |> Ecto.Date.to_string

    json conn, %{date: date}
  end
end
