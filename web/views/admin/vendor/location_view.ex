defmodule Grid.Admin.Vendor.LocationView do
  use Grid.Web, :view

  def state_options do
    Grid.USStates.states_and_codes()
  end
end
