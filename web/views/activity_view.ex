defmodule Grid.ActivityView do
  use Grid.Web, :view

  alias Grid.Image
  alias Grid.Vendor
  alias Grid.Experience

  def img(nil, opts), do: tag(:img, opts)
  def img(%Image{} = image, opts) do
    opts = opts
    |> Keyword.put_new(:src, image.medium)
    |> Keyword.put_new(:alt, image.alt)
    |> Keyword.put_new(:title, image.filename)
    tag(:img, opts)
  end

  def img_for(%Vendor{} = vendor, opts) do
    img(vendor.default_image, opts)
  end
  def img_for(%Experience{} = experience, opts) do
    img(experience.image, opts)
  end
end
