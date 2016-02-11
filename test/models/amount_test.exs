defmodule Grid.AmountTest do
  use Grid.ModelCase

  alias Grid.Amount

  @valid_attrs %{amount: "120.5", min_quantity: 0, max_quantity: 0}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Amount.changeset(%Amount{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Amount.changeset(%Amount{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset with invalid min/max" do
    changeset = Amount.changeset(%Amount{}, %{@valid_attrs | min_quantity: 5, max_quantity: 4})
    refute changeset.valid?
  end

  test "changeset with valid min/max, where max is 0" do
    changeset = Amount.changeset(%Amount{}, %{@valid_attrs | min_quantity: 50, max_quantity: 0})
    assert changeset.valid?
  end
end
