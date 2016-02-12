defmodule Grid.Api.StartTimeView do
  use Grid.Web, :view

  def render("start_time.json", %{start_time: start_time}) do
    %{
      id: start_time.id,
      starts_at_time: start_time.starts_at_time,

      monday: start_time.monday,
      tuesday: start_time.tuesday,
      wednesday: start_time.wednesday,
      thursday: start_time.thursday,
      friday: start_time.friday,
      saturday: start_time.saturday,
      sunday: start_time.sunday,

      season: start_time.season_id,
      product: start_time.product_id
    }
  end
end
