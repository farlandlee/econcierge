defmodule Grid.Api.ImageView do
  use Grid.Web, :view

  def render("image.json", %{image: %{error: true}}) do
    %{}
  end
  def render("image.json", %{image: image}) do
    %{
      title: image.filename,
      alt: image.alt,
      full: image.original,
      medium: image.medium,
      large: image.large,
      thumb: image.thumb,
      position: image.position
    }
  end
end
