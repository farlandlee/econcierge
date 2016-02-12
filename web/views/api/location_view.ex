defmodule Grid.Api.LocationView do
  use Grid.Web, :view

  def render("location.json", %{location: location}) do
    %{
      id: location.id,
      vendor: location.vendor_id,
      name: location.name,
      address1: location.address1,
      address2: location.address2,
      city: location.city,
      state: location.state,
      zip: location.zip
    }
  end
end
