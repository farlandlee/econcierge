defmodule Grid.ActivityCategoryTest do
  use Grid.ModelCase

  alias Grid.ActivityCategory

  @valid_attrs %{activity_id: 42, category_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ActivityCategory.changeset(%ActivityCategory{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ActivityCategory.changeset(%ActivityCategory{}, @invalid_attrs)
    refute changeset.valid?
  end
end
