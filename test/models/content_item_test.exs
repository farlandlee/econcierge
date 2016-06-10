defmodule Grid.ContentItemTest do
  use Grid.ModelCase

  alias Grid.ContentItem

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "creation changeset" do
    changeset = ContentItem.creation_changeset("test", "test", "test")
    assert changeset.valid?
  end

  test "changeset with valid attributes" do
    changeset = ContentItem.changeset(%ContentItem{}, @valid_attrs)
    assert changeset.valid?
  end
end
