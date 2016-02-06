defmodule Grid.VendorTest do
  use Grid.ModelCase

  alias Grid.Vendor

  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Vendor.changeset(%Vendor{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Vendor.changeset(%Vendor{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "Changeset with long description" do
    changeset = Vendor.changeset(%Vendor{},
      %{@valid_attrs | description: long_string(300)})
    assert changeset.valid?
  end
end
