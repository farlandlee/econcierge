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

  def target_path(target, activity, nil) do
    activity_path(Grid.Endpoint, String.to_existing_atom("#{target}_by_activity_slug"), activity.slug)
  end
  def target_path(target, activity, category) do
    activity_path(Grid.Endpoint, String.to_existing_atom("#{target}_by_activity_and_category_slugs"), activity.slug, category.slug)
  end
end
