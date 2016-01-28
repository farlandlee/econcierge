defmodule Grid.LocationTest do
  use Grid.ModelCase

  alias Grid.Location

  import Ecto.Changeset, only: [fetch_field: 2]

  @valid_attrs %{name: "name", address1: "some content", city: "some content", state: "WY", zip: "some content"}
  @invalid_attrs %{state: "not a real state"}

  test "changeset with valid attributes" do
    changeset = Location.changeset(%Location{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Location.changeset(%Location{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "creation_changeset takes vendor_id" do
    changeset = Location.creation_changeset(@valid_attrs, 1)
    assert changeset.valid?
    assert fetch_field(changeset, :vendor_id) == {:changes, 1}
  end

  test "can't change vendor via normal changeset" do
    valid_location = Map.merge(%Location{vendor_id: 1337}, @valid_attrs)
    changeset = Location.changeset(valid_location, %{vendor_id: -1337})
    assert changeset.valid?
    assert fetch_field(changeset, :vendor_id) == {:model, 1337}
  end
end
