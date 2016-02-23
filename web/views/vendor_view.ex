defmodule Grid.VendorView do
  use Grid.Web, :view

  alias Grid.Image

  def img_src(_, size \\ :medium)
  def img_src(nil, _), do: "http://placehold.it/450x300"
  def img_src(%Image{} = image, size) do
    Map.get(image, size)
  end
end
