defmodule Grid.VendorActivityTest do
  use Grid.ModelCase

  alias Grid.VendorActivity

  @valid_attrs %{vendor_id: 1, activity_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = VendorActivity.changeset(%VendorActivity{}, @valid_attrs)
    assert changeset.valid?
  end

  # @TODO
  # test "changeset with invalid attributes" do
  #   changeset = VendorActivity.changeset(%VendorActivity{}, @invalid_attrs)
  #   refute changeset.valid?
  # end
end
