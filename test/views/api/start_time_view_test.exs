defmodule Grid.Api.StartTimeViewTest do
  use Grid.ConnCase

  import Grid.Api.StartTimeView

  test "render start_time" do
    start_time = Factory.create_start_time

    rendered_start_time = render("start_time.json", %{start_time: start_time})

    for key <- ~w(id starts_at_time monday tuesday wednesday thursday friday saturday sunday)a do
      assert Map.has_key?(rendered_start_time, key)
      assert rendered_start_time[key] == Map.get(start_time, key)
    end

    refute Map.has_key?(rendered_start_time, :product_id)
    assert Map.has_key?(rendered_start_time, :product)
    assert rendered_start_time.product == start_time.product_id

    # start times don't render seasons
    refute Map.has_key?(rendered_start_time, :season_id)
    refute Map.has_key?(rendered_start_time, :season)
    # made up keys! not on the server, but we spoof it for the kids
    season = start_time.season
    for season_field <- ~w(start_date end_date)a do
      assert Map.has_key?(rendered_start_time, season_field)
      assert rendered_start_time[season_field] == Map.get(season, season_field)
    end
  end
end
