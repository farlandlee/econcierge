defmodule Grid.SeasonTest do
  use Grid.ModelCase

  alias Grid.Season

  @valid_attrs %{
    name: "some content",
    start_date_day: 17, start_date_month: 4,
    end_date_day: 4, end_date_month: 12
  }
  @invalid_attrs %{
    name: "Peak Season",
  start_date_day: 100, start_date_month: 101,
  end_date_day: -4, end_date_month: 1337}

  test "changeset with valid attributes" do
    changeset = Season.changeset(%Season{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Season.changeset(%Season{}, @invalid_attrs)
    refute changeset.valid?
  end
end
