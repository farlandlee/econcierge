defmodule Grid.API.CategoryView do
  use Grid.Web, :view

  def render("index.json", %{categories: categories}) do
    %{categories: render_many(categories, Grid.API.CategoryView, "category.json")}
  end

  def render("show.json", %{category: category}) do
    %{category: render_one(category, Grid.API.CategoryView, "category.json")}
  end

  def render("category.json", %{category: category}) do
    %{
      id: category.id,
      name: category.name,
      description: category.description,
      slug: category.slug
    }
  end
end
