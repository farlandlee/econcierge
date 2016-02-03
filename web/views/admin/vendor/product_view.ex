defmodule Grid.Admin.Vendor.ProductView do
  use Grid.Web, :view

  alias Grid.Admin.Vendor.LocationView

  def check_icon(true), do: check_icon("check")
  def check_icon(false), do: check_icon("unchecked")
  def check_icon(class) do
    tag :span, class: "glyphicon glyphicon-#{class}"
  end

  def pretty_duration(minutes) do
    {hours, minutes} = {div(minutes, 60), rem(minutes, 60)}
    minutes = minutes
      |> to_string
      |> String.rjust(2, ?0)
    "#{hours}h #{minutes}m"
  end

  def duration_input(f, field, opts) do
    duration = field_value(f, :duration) || 0
    value = case field do
      :duration_hours   -> duration |> div(60)
      :duration_minutes -> duration |> rem(60)
    end
    number_input f, field, [min: 0, value: value] ++ opts
  end

  def vendor_or_experience_header(:vendor),     do: "Vendor"
  def vendor_or_experience_header(:experience), do: "Experience"

  def vendor_or_experience(:vendor, product) do
    vendor = product.vendor
    link(vendor.name, to: admin_vendor_path(Grid.Endpoint, :show, vendor))
  end
  def vendor_or_experience(:experience, product) do
    experience = product.experience
    link(experience.name,
      to: admin_activity_experience_path(Grid.Endpoint, :show, experience.activity_id, experience)
    )
  end
end
