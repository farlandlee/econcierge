defmodule Grid.Admin.Vendor.ImageView do
  use Grid.Web, :view
  alias Grid.Image

  def caption(%Image{alt: alt})
  when alt == "" or alt == nil do
    content_tag(:i, "No caption")
  end
  def caption(%Image{alt: alt}) do
    content_tag(:p, alt)
  end
end
