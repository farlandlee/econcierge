defmodule Grid.Admin.CouponTest do
  use Grid.ModelCase

  alias Grid.Coupon

  @valid_attrs %{code: "VALID_CODE_23", disabled: false, expiration_date: "2017-04-17", usage_count: 0, max_usage_count: 42, percent_off: 42}
  @invalid_attrs %{percent_off: -1}

  test "changeset updates code" do
    changeset = Coupon.changeset(%Coupon{}, %{@valid_attrs | code: "hey whats up"})
    assert changeset.changes.code == "HEY_WHATS_UP"
    assert changeset.valid?
  end

  test "changeset errors on invalid code" do
    changeset = Coupon.changeset(%Coupon{}, %{code: "can't have apostrophes"})
    refute changeset.valid?
  end

  test "changeset with valid attributes" do
    changeset = Coupon.changeset(%Coupon{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Coupon.changeset(%Coupon{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset ignores usage count" do
    changeset = Coupon.changeset(%Coupon{}, %{@valid_attrs | usage_count: 100})
    refute Map.has_key? changeset.changes, :usage_count
    assert changeset.valid?
  end
end
