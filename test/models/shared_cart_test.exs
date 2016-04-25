defmodule Grid.SharedCartTest do
  use Grid.ModelCase

  alias Grid.SharedCart

  @valid_attrs %{"bookings" => [%{
        "activity" => "1",
        "category" => "2",
        "date" => "2016-04-25",
        "experience" => "2",
        "product" => "7",
        "quantities" => [%{"cost" => 100, "id" => 13, "quantity" => 1}],
        "startTime" => %{"id" => 7, "time" => "00:00:00"}
      }]}
  @invalid_attrs %{}

  test "creation changeset" do
    changeset = SharedCart.creation_changeset(@valid_attrs)
    assert changeset.valid?
  end
end
