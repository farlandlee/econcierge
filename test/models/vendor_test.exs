defmodule Grid.VendorTest do
  use Grid.ModelCase

  alias Grid.Vendor

  import Ecto.Changeset, only: [fetch_change: 2]

  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Vendor.changeset(%Vendor{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Vendor.changeset(%Vendor{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "Changeset with long description" do
    changeset = Vendor.changeset(%Vendor{},
      %{@valid_attrs | description: long_string(300)})
    assert changeset.valid?
  end

  test "changeset with invalid TripAdvisor location id" do
    attrs = @valid_attrs |> Map.put(:tripadvisor_location_id, "d123456789")
    changeset = Vendor.changeset(%Vendor{}, attrs)
    assert [tripadvisor_location_id: "Cannot start with the letter d"] = changeset.errors
  end

  test "clearing out of TripAdvisor data" do
    changeset = %Vendor{
      tripadvisor_location_id: 12345,
      tripadvisor_rating: 4.8,
      tripadvisor_rating_image_url: "http://example.com",
      tripadvisor_reviews_count: 53
    } |> Vendor.changeset(%{tripadvisor_location_id: nil})

    assert {:ok, nil} = fetch_change(changeset, :tripadvisor_location_id)
    assert {:ok, nil} = fetch_change(changeset, :tripadvisor_rating)
    assert {:ok, nil} = fetch_change(changeset, :tripadvisor_rating_image_url)
    assert {:ok, nil} = fetch_change(changeset, :tripadvisor_reviews_count)
  end
end
