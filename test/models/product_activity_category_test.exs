defmodule Grid.ProductActivityCategoryTest do
  use Grid.ModelCase

  alias Grid.ProductActivityCategory

  @valid_attrs %{activity_category_id: 1, product_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ProductActivityCategory.changeset(%ProductActivityCategory{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ProductActivityCategory.changeset(%ProductActivityCategory{}, @invalid_attrs)
    refute changeset.valid?
  end
end
