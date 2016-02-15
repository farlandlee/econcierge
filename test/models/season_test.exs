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
end
