defmodule Grid.Admin.VendorView do
  use Grid.Web, :view

  def activity_ids(%{model: %{activities: activities}}) when is_list(activities) do
    Enum.map(activities, &(&1.id))
  end
  def activity_ids(_), do: []

  def vendor_img(form_or_image, opts \\ [])
  def vendor_img(%{model: model}, opts) do
    vendor_img(model, opts)
  end
  def vendor_img(nil, _), do: ""
  def vendor_img(vendor, opts) do
    image = vendor.default_image
    if image do
      if image.medium do
        opts = opts
        |> Keyword.put_new(:src, image.medium)
        |> Keyword.put_new(:alt, image.alt)
        |> Keyword.put_new(:title, image.filename)
        tag(:img, opts)
      else
        content_tag(:p, "The image is still uploading")
      end
    else
      content_tag(:p, "No image found.")
    end
  end

  def pretty_activities(activities) do
    activities
    |> Enum.map(&(&1.name))
    |> Enum.join(" | ")
  end

end
