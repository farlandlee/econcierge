defmodule Grid.Admin.ImageView do
  use Grid.Web, :view

  alias Grid.Image

  def image_path(path_fun, args) do
    apply Grid.Router.Helpers, path_fun, args
  end

  def img(image, opts \\ [])
  def img(nil, _opts), do: "No image"
  def img(%Image{medium: nil, filename: name, error: false}, _opts) do
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
