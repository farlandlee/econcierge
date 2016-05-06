defmodule Grid.Api.CategoryController do
  use Grid.Web, :controller

  alias Grid.Category

  def index(conn, params) do
    categories = Category.by_activity(params["activity_id"])
      |> Category.having_published_products
      |> Repo.all_in_ids(params["ids"])
      |> Repo.preload(:image)

    render(conn, "index.json", categories: categories)
  end

  def show(conn, %{"id" => id}) do
    category = Repo.get!(Category, id)
      |> Repo.preload(:image)
    render(conn, "show.json", category: category)
  end
end
