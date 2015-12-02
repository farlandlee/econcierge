defmodule Grid.ActivityTypeTest do
  use Grid.ModelCase

  alias Grid.ActivityType

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ActivityType.changeset(%ActivityType{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ActivityType.changeset(%ActivityType{}, @invalid_attrs)
    refute changeset.valid?
  end
end
