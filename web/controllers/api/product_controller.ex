defmodule Grid.Api.ProductController do
  use Grid.Web, :controller

  import Ecto.Query

  alias Grid.Product

  plug :assign_date when action in [:index]

  def index(conn, params) do
    products = Product.published
      |> Product.for_date(conn.assigns.date)
      |> Product.for_category(params["category_id"])
      |> distinct(true)
      |> Repo.all
      |> preload
      |> filter_check

    render(conn, "index.json", products: products)
  end

  def show(conn, %{"id" => id}) do
    product = Product.published
      |> Repo.get!(id)
      |> preload
    render(conn, "show.json", product: product)
  end

  def preload(products) do
    Repo.preload(products, [
      :product_amenity_options,
      :meeting_location,
      :images,
      :default_image,
      start_times: :season,
      prices: :amounts,
      default_price: :amounts
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

  defp filter_check(products) do
    Enum.filter(products, fn(product) ->
      case Grid.Product.check_bookability(product) do
        {:ok, _} -> true
        _ -> false
      end
    end)
  end
end
