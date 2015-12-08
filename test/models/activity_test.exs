defmodule Grid.ActivityTest do
  use Grid.ModelCase

  alias Grid.Activity

  @valid_attrs %{name: "some content", description: "some description"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Activity.changeset(%Activity{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Activity.changeset(%Activity{}, @invalid_attrs)
    refute changeset.valid?
  end
end
