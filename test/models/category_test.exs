defmodule Grid.CategoryTest do
  use Grid.ModelCase

  alias Grid.Category

  @valid_attrs %{name: "some content", description: "some description", activity_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Category.changeset(%Category{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Category.changeset(%Category{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "creation_changeset with valid attributes" do
    changeset = Category.creation_changeset(@valid_attrs, 1)
    assert changeset.valid?
  end

  test "creation_changeset with invalid attributes" do
    changeset = Category.creation_changeset(@invalid_attrs, nil)
    refute changeset.valid?
  end
end
