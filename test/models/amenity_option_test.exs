defmodule Grid.AmenityOptionTest do
  use Grid.ModelCase

  alias Grid.AmenityOption

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "creation changeset with valid attributes" do
    changeset = AmenityOption.creation_changeset(@valid_attrs, 1)
    assert changeset.valid?
  end

  test "creation changeset with invalid attributes" do
    changeset = AmenityOption.creation_changeset(@invalid_attrs, 1)
    refute changeset.valid?
  end

  test "changeset with valid attributes" do
    changeset = AmenityOption.changeset(%AmenityOption{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = AmenityOption.changeset(%AmenityOption{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "require name between 1-255 characters" do
    changeset = %AmenityOption{}
      |> AmenityOption.changeset(%{@valid_attrs | name: ""})

    refute changeset.valid?
    assert [name: {"should be at least %{count} character(s)", [count: 1]}] = changeset.errors

    changeset = %AmenityOption{}
      |> AmenityOption.changeset(%{@valid_attrs | name: Grid.TestHelper.long_string(300)})

    refute changeset.valid?
    assert [name: {"should be at most %{count} character(s)", [count: 255]}] = changeset.errors
  end
end
