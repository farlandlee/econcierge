defmodule Grid.Admin.Activity.ImageView do
  use Grid.Web, :view
  alias Grid.Image

  def img(image, opts \\ [])
  def img(nil, opts), do: "No image"
  def img(%Image{medium: nil, filename: name}, opts) do
    content_tag(:p, "#{name} still uploading...")
  end
  def img(img, opts)do
    options = [src: img.medium, alt: img.alt, title: img.filename]
      |> Keyword.merge(opts)
    tag(:img, options)
  end

  def filename(nil), do: "No Image"
  def filename(%Image{filename: name}), do: name

  def caption(%Image{alt: alt})
  when alt == "" or alt == nil do
    content_tag(:i, "No caption")
  end
  def caption(%Image{alt: alt}) do
    content_tag(:p, alt)
  end
end
