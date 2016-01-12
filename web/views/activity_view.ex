defmodule Grid.ActivityView do
  use Grid.Web, :view

  alias Grid.Image

  def img(nil, opts), do: tag(:img, opts)
  def img(%Image{} = image, opts) do
    opts = opts
    |> Keyword.put_new(:src, image.medium)
    |> Keyword.put_new(:alt, image.alt)
    |> Keyword.put_new(:title, image.filename)
    tag(:img, opts)
  end
end
