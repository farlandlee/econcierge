defmodule Grid.OrderTest do
  use Grid.ModelCase

  alias Grid.Order

  @valid_attrs %{total_amount: "120.5"}
  @invalid_attrs %{total_amount: "-100.20"}

  test "creation changeset with valid attributes" do
    changeset = Order.creation_changeset(@valid_attrs, user_id: 1)
    assert changeset.valid?
  end

  test "creation changeset with invalid attributes" do
    changeset = Order.creation_changeset(@invalid_attrs, user_id: nil)
    refute changeset.valid?
  end
end
