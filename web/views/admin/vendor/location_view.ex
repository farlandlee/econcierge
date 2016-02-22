defmodule Grid.Admin.Vendor.LocationView do
  use Grid.Web, :view

  alias Grid.Location

  def state_options do
    Grid.USStates.states_and_codes()
  end

  def pretty_location(nil) do
    ~E"<b>error</b> Location missing"
  end
  def pretty_location(%Location{} = location) do
    ~E"""
    <address>
      <strong><%= location.name %></strong><br>
      <%= location.address1 %><%= if a2=location.address2, do: ", " <> a2 %><br>
      <%= location.city %>, <%= location.state %> <%= location.zip %>
    </address>
    """
  end
end
