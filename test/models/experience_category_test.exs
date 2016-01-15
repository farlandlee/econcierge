defmodule Grid.ExperienceCategoryTest do
  use Grid.ModelCase

  alias Grid.ExperienceCategory

  @valid_attrs %{experience_id: 42, category_id: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ExperienceCategory.changeset(%ExperienceCategory{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ExperienceCategory.changeset(%ExperienceCategory{}, @invalid_attrs)
    refute changeset.valid?
  end
end
