defmodule Grid.Api.ExperienceController do
  use Grid.Web, :controller

  import Ecto.Query

  alias Grid.{
    Experience,
    Product
  }

  def index(conn, params) do
    product_ids = get_product_ids_for_date(params["date"])

    experiences = Experience
      |> Experience.for_activity(params["activity_id"])
      |> Experience.for_category(params["category_id"])
      |> Experience.having_published_products(product_ids)
      |> Repo.all

    render(conn, "index.json", experiences: experiences)
  end

  def show(conn, %{"slug" => slug}) do
    experience = Experience |> Repo.get_by!(slug: slug)
    render(conn, "show.json", experience: experience)
  end

  defp get_product_ids_for_date(nil), do: nil
  defp get_product_ids_for_date(date) do
    case Ecto.Date.cast(date) do
      {:ok, date} ->
        product_ids = Product.published
        |> Product.for_date(date)
        |> select([p], p.id)
        |> Repo.all

        product_ids
      _ -> nil
    end
  end
end
