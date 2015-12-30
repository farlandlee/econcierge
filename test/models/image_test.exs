defmodule Grid.ImageTest do
  use Grid.ModelCase

  alias Grid.Image

  @valid_attrs %{alt: "some content", filename: "weee.png"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Image.changeset(%Image{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Image.changeset(%Image{}, @invalid_attrs)
    refute changeset.valid?
  end
end
