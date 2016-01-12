defmodule Grid.ExperienceTest do
  use Grid.ModelCase

  alias Grid.Experience

  @valid_attrs %{description: "some content", name: "some content", activity_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Experience.changeset(%Experience{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Experience.changeset(%Experience{}, @invalid_attrs)
    refute changeset.valid?
  end
end
