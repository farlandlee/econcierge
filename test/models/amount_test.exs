defmodule Grid.AmountTest do
  use Grid.ModelCase

  alias Grid.Amount

  @valid_attrs %{amount: "120.5", max_quantity: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Amount.changeset(%Amount{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Amount.changeset(%Amount{}, @invalid_attrs)
    refute changeset.valid?
  end
end
