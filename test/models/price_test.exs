defmodule Grid.PriceTest do
  use Grid.ModelCase

  alias Grid.Price

  @valid_attrs %{amount: "120.5", description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Price.changeset(%Price{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Price.changeset(%Price{}, @invalid_attrs)
    refute changeset.valid?
  end
end
