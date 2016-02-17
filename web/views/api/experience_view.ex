defmodule Grid.Api.ExperienceView do
  use Grid.Web, :view

  def render("index.json", %{experiences: experiences}) do
    %{experiences: render_many(experiences, __MODULE__, "experience.json")}
  end

  def render("show.json", %{experience: experience}) do
    %{experience: render_one(experience, __MODULE__, "experience.json")}
  end

  def render("experience.json", %{experience: experience}) do
    %{
      id: experience.id,
      name: experience.name,
      description: experience.description,
      slug: experience.slug,
      image: render_one(experience.image, Grid.Api.ImageView, "image.json")
    }
  end
end
