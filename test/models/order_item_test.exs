defmodule Grid.OrderItemTest do
  use Grid.ModelCase

  alias Grid.OrderItem

  @two_days_from_now Calendar.DateTime.now_utc
    |> Calendar.DateTime.advance!(2 * 24 * 60 * 60)

  @valid_attrs %{
    order_id: 1,
    product_id: 2,
    activity_at: @two_days_from_now,
    amount: 120.5,
    client_id: "af0de8",
    quantities: %{
      items: [
        %{price_id: 1, sub_total: 120.5, quantity: 3,
          price_name: "Adults", price_people_count: 1}
      ]
    }
  }

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = OrderItem.changeset(%OrderItem{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = OrderItem.changeset(%OrderItem{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "changeset quantities validation" do
    attrs = @valid_attrs |> Map.put(:quantities, %{})
    changeset = OrderItem.changeset(%OrderItem{}, attrs)
    refute changeset.valid?

    attrs = @valid_attrs |> Map.put(:quantities, %{items: []})
    changeset = OrderItem.changeset(%OrderItem{}, attrs)
    refute changeset.valid?

    attrs = @valid_attrs |> Map.put(:quantities, %{items: [%{}]})
    changeset = OrderItem.changeset(%OrderItem{}, attrs)
    refute changeset.valid?
  end
end
