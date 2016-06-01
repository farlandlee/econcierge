defmodule Grid.KioskSlideTest do
  use Grid.ModelCase

  alias Grid.KioskSlide

  test "changeset with valid attributes" do
    changeset = KioskSlide.creation_changeset(1, 1)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = KioskSlide.creation_changeset(nil, nil)
    refute changeset.valid?
  end
end
