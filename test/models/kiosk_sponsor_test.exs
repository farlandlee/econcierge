defmodule Grid.KioskSponsorTest do
  use Grid.ModelCase

  alias Grid.KioskSponsor

  @valid_attrs %{kiosk_id: 1, vendor_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = KioskSponsor.creation_changeset(1, 1)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = KioskSponsor.creation_changeset(nil, nil)
    refute changeset.valid?
  end
end
