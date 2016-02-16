defmodule Grid.SeasonTest do
  use Grid.ModelCase

  alias Grid.Season

  @valid_attrs %{
    name: "some content",
    start_date: "2016-04-17",
    end_date: "2016-06-12"
  }
  @invalid_attrs %{
    name: "Peak Season",
    start_date: "2016-04-17",
    end_date: "2016-02-17"
  }

  test "changeset with valid attributes" do
    changeset = Season.changeset(%Season{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Season.changeset(%Season{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "first_from_date" do
    season = Factory.create(:season)

    erl_start = Ecto.Date.to_erl(season.start_date)

    date_before_season = Calendar.Date.advance!(erl_start, -5) |> Calendar.Date.to_erl
    result = Season.first_from_date(date_before_season) |> Repo.one!
    assert season.id == result.id

    date_in_season = Calendar.Date.advance!(erl_start, 2) |> Calendar.Date.to_erl
    result = Season.first_from_date(date_in_season) |> Repo.one!
    assert season.id == result.id

    erl_end = Ecto.Date.to_erl(season.end_date)
    date_after_season = Calendar.Date.advance!(erl_end, 5) |> Calendar.Date.to_erl

    assert_raise(Ecto.NoResultsError, fn ->
      Season.first_from_date(date_after_season) |> Repo.one!
    end)

  end
end
