defmodule Grid.VendorActivityTypeTest do
  use Grid.ModelCase

  alias Grid.VendorActivityType

  @valid_attrs %{vendor_id: 1, activity_type_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = VendorActivityType.changeset(%VendorActivityType{}, @valid_attrs)
    assert changeset.valid?
  end

  # @TODO
  # test "changeset with invalid attributes" do
  #   changeset = VendorActivityType.changeset(%VendorActivityType{}, @invalid_attrs)
  #   refute changeset.valid?
  # end
end
