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

      # Pretend that seasons aren't a thing,
      # and that the dates are from the times themselves
      start_date: start_time.season.start_date,
      end_date: start_time.season.end_date,
      product: start_time.product_id
    }
  end
end
