defmodule Grid.Api.ExperienceController do
  use Grid.Web, :controller

  import Ecto.Query

  alias Grid.{
    Experience,
    Product
  }

  plug :assign_products_for_date when action in [:index]

  def index(conn, params) do
    experiences = Experience
      |> Experience.for_activity(params["activity_id"])
      |> Experience.for_category(params["category_id"])
      |> Experience.having_published_products(conn.assigns.products)
      |> Repo.all

    render(conn, "index.json", experiences: experiences)
  end

  def show(conn, %{"slug" => slug}) do
    experience = Experience |> Repo.get_by!(slug: slug)
    render(conn, "show.json", experience: experience)
  end

  ###########
  ## Plugs ##
  ###########

  defp assign_products_for_date(conn, _) do
    products = case Grid.Dates.parse_date(conn.params["date"]) do
      {:ok, date} ->
        if date |> Calendar.Date.after?(:erlang.date()) do
          Product.published
          |> Product.for_date(date)
          |> select([p], p.id)
          |> Repo.all
        else
          []
        end
      {_, nil} ->  nil
    end

    assign(conn, :products, products)
  end
end
