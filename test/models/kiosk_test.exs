defmodule Grid.KioskTest do
  use Grid.ModelCase

  alias Grid.Kiosk

  @valid_attrs %{name: "some content", sub_domain: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Kiosk.changeset(%Kiosk{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Kiosk.changeset(%Kiosk{}, @invalid_attrs)
    refute changeset.valid?
  end
end
