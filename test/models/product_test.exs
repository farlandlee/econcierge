defmodule Grid.ProductTest do
  use Grid.ModelCase

  alias Grid.Product
  import Ecto.Changeset, only: [fetch_field: 2]

  @valid_attrs %{description: "some content", name: "some content", duration: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Product.changeset(%Product{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Product.changeset(%Product{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "creation_changeset with valid attributes" do
    vendor = Factory.create(:vendor)
    experience = Factory.create(:experience)
    attrs = @valid_attrs |> Map.put(:experience_id, experience.id)
    changeset = Product.creation_changeset(attrs, vendor.id)
    assert changeset.valid?
  end

  test "creation_changeset with invalid attributes" do
    changeset = Product.creation_changeset(@invalid_attrs, 2)
    refute changeset.valid?
  end

  test "setting pickup to false without providing a location errors" do
    params = @valid_attrs |> Map.put(:pickup, false)
    changeset = Product.changeset(%Product{}, params)
    assert [meeting_location_id: "Please supply a meeting location."] == changeset.errors
  end

  test "Selecting a location sets pickup to false" do
    params = @valid_attrs |> Map.put(:meeting_location_id, 1)
    changeset = Product.changeset(%Product{}, params)
    assert {:changes, false} == fetch_field(changeset, :pickup)
  end

  test "Setting pickup to true clears the meeting location id" do
    params = @valid_attrs |> Map.put(:pickup, true)
    changeset = Product.changeset(%Product{meeting_location_id: 1, pickup: false}, params)
    assert {:changes, nil} == fetch_field(changeset, :meeting_location_id)
  end

end
