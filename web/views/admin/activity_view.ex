defmodule Grid.Admin.ActivityView do
  use Grid.Web, :view

  import Grid.AdminView, only: [tab_link: 1, icon: 1]

  def photo_card_icon(true), do: icon("check")
  def photo_card_icon(_), do: icon("unchecked")
end
