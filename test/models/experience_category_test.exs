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

  test "category deletion cascades" do
    ec = Factory.create(:experience_category)
    Repo.delete! ec.category
    assert_raise Ecto.NoResultsError, fn ->
      Repo.get! ExperienceCategory, to_string(ec.id)
    end
  end

  test "experience deletion cascades" do
    ec = Factory.create(:experience_category)
    Repo.delete! ec.experience
    assert_raise Ecto.NoResultsError, fn ->
      Repo.get! ExperienceCategory, ec.id
    end
  end
end
