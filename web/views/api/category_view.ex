defmodule Grid.Api.CategoryView do
  use Grid.Web, :view

  def render("index.json", %{categories: categories}) do
    %{categories: render_many(categories, Grid.Api.CategoryView, "category.json")}
  end

  def render("show.json", %{category: category}) do
    %{category: render_one(category, Grid.Api.CategoryView, "category.json")}
  end

  def render("category.json", %{category: category}) do
    %{
      id: category.id,
      name: category.name,
      description: category.description,
      slug: category.slug,
      activity: category.activity_id,
      image: render_one(category.image, Grid.Api.ImageView, "image.json")
    }
  end
end
