defmodule Grid.AmenityTest do
  use Grid.ModelCase

  alias Grid.Amenity

  @valid_attrs %{name: "Some Amenity"}
  @invalid_attrs %{}

  test "creation changeset with valid attributes" do
    changeset = Amenity.creation_changeset(@valid_attrs, 1)
    assert changeset.valid?
  end

  test "creation changeset with invalid attributes" do
    changeset = Amenity.creation_changeset(@invalid_attrs, 1)
    refute changeset.valid?
  end

  test "changeset with valid attributes" do
    changeset = Amenity.changeset(%Amenity{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Amenity.changeset(%Amenity{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "require name between 1-255 characters" do
    changeset = %Amenity{}
      |> Amenity.changeset(%{@valid_attrs | name: ""})

    refute changeset.valid?
    assert [name: {"should be at least %{count} character(s)", [count: 1]}] = changeset.errors

    changeset = %Amenity{}
      |> Amenity.changeset(%{@valid_attrs | name: long_string(300)})

    refute changeset.valid?
    assert [name: {"should be at most %{count} character(s)", [count: 255]}] = changeset.errors
  end
end
