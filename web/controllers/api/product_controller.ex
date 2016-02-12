defmodule Grid.Api.ProductController do
  use Grid.Web, :controller

  alias Grid.Product

  plug :assign_date when action in [:index]

  def index(conn, params) do
    products = Product.published
      |> Product.for_date(conn.assigns.date)
      |> Product.for_experience(params["experience_id"])
      |> Repo.all
      |> preload
    render(conn, "index.json", products: products)
  end

  def show(conn, %{"id" => id}) do
    product = Product.published
      |> Repo.get!(id)
      |> preload
    render(conn, "show.json", product: product)
  end

  def preload(query_or_products) do
    Repo.preload(query_or_products, [
      :amenity_options,
      :meeting_location,
      start_times: :season,
      prices: :amounts,
    ])
  end

  defp assign_date(conn = %{params: %{"date" => date}}, _) do
    date = case Ecto.Date.cast(date) do
      {:ok, date} -> date
      _ -> nil
    end
    assign(conn, :date, date)
  end
  defp assign_date(conn, _), do: assign(conn, :date, nil)
end
