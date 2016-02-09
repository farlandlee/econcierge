defmodule Grid.API.CategoryController do
  use Grid.Web, :controller

  alias Grid.Category

  def index(conn, params) do
    categories = Category.by_activity(params["activity_id"])
      |> Repo.all
    render(conn, "index.json", categories: categories)
  end

  def show(conn, %{"slug" => slug}) do
    category = Category |> Repo.get_by!(slug: slug)
    render(conn, "show.json", category: category)
  end
end