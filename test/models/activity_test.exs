defmodule Grid.ActivityTest do
  use Grid.ModelCase

  alias Grid.Activity
  alias Grid.TestHelper

  @valid_attrs %{name: "some content", description: "some description"}
  @invalid_attrs %{}

  setup do
    Ecto.Adapters.SQL.restart_test_transaction(Grid.Repo)
    :ok
  end

  test "changeset with valid attributes" do
    changeset = Activity.changeset(%Activity{}, @valid_attrs)
    assert changeset.valid?
  end

  test "require name between 1-255 characters" do
    changeset = %Activity{}
      |> Activity.changeset(%{@valid_attrs | name: ""})

    refute changeset.valid?
    assert [name: {"should be at least %{count} characters", [count: 1]}] = changeset.errors

    changeset = %Activity{}
      |> Activity.changeset(%{@valid_attrs | name: TestHelper.long_string(300)})

    refute changeset.valid?
    assert [name: {"should be at most %{count} characters", [count: 255]}] = changeset.errors
  end

  test "can't save the same name twice" do
    changeset = Activity.changeset(%Activity{}, @valid_attrs)
    assert {:ok, _} = Repo.insert(changeset)
    assert {:error, _} = Repo.insert(changeset)
  end

end
