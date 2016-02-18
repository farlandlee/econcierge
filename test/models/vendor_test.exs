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

  test "sets tripadvisor should update" do
    attrs = @valid_attrs |> Map.put(:tripadvisor_location_id, "12345")
    changeset = Vendor.changeset(%Vendor{}, attrs)

    assert {:ok, "12345"} = fetch_change(changeset, :tripadvisor_location_id)
    assert {:ok, true} = fetch_change(changeset, :tripadvisor_should_update)
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

  test "If tripadvisor_location_id is not in changes, don't clear out TripAdvisor data" do
    changeset = %Vendor{
      tripadvisor_location_id: 12345,
      tripadvisor_rating: 4.8,
      tripadvisor_rating_image_url: "http://example.com",
      tripadvisor_reviews_count: 53
    } |> Vendor.changeset(%{name: "New Name"})

    assert :error = fetch_change(changeset, :tripadvisor_location_id)
    assert :error = fetch_change(changeset, :tripadvisor_rating)
    assert :error = fetch_change(changeset, :tripadvisor_rating_image_url)
    assert :error = fetch_change(changeset, :tripadvisor_reviews_count)
  end
end
