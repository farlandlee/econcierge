defmodule Grid.StartTimeTest do
  use Grid.ModelCase

  alias Grid.StartTime

  @valid_attrs %{starts_at_time: "14:00:00"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = StartTime.changeset(%StartTime{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = StartTime.changeset(%StartTime{}, @invalid_attrs)
    refute changeset.valid?
  end
end
