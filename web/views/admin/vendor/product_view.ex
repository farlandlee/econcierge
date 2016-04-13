defmodule Grid.Admin.Vendor.ProductView do
  use Grid.Web, :view

  import Grid.AdminView, only: [tab_link: 1]

  alias Grid.{
    Admin.Vendor.LocationView,
    Product
  }

  def icon(class) do
    ~E"""
    <span class="glyphicon glyphicon-<%= class %>"></span>
    """
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

  def amenity_option_selected?(form, amenity_option) do
    f = if ids = form.params["amenity_option_id"] do
      # The user made selections in a previous incarnation
      # of this form; keep their changes around
      fn %{id: id} -> (id |> to_string) in ids end
    else
      # the user hasn't made any changes, so the product's
      # amenity options are the ones that are selected
      model_id = form.model.id
      fn %{product_id: prod_id} -> prod_id == model_id end
    end
    Enum.any?(amenity_option.product_amenity_options, f)
  end

  def published_icon(%Product{published: true} = product) do
    Product.check_bookability(product)
    |> published_icon
  end
  def published_icon(%Product{published: false}), do: icon("unchecked")
  def published_icon({:ok, %Product{published: false}}), do: icon("unchecked")
  def published_icon({:ok, %Product{published: true}}), do: icon("check")
  def published_icon({:error, errors}) when is_list(errors), do: icon("warning-sign")

  def pretty_errors({:ok, _}), do: ""
  def pretty_errors({:error, errors}) do
    Enum.join(errors, " | ")
  end
end
