defmodule Grid.ContentItemTest do
  use Grid.ModelCase

  alias Grid.ContentItem

  @valid_attrs %{content: "some content", context: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ContentItem.changeset(%ContentItem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ContentItem.changeset(%ContentItem{}, @invalid_attrs)
    refute changeset.valid?
  end
end
