defmodule Grid.ModelsTest do
  use ExUnit.Case, async: true

  import Ecto.Changeset

  # Modules we're testing
  import Grid.Models.Slug, only: [cast_slug: 1, cast_slug: 2]

  # Dummy model for testerizing with
  defmodule Model do
    use Ecto.Schema

    schema "models" do
      field :name, :string
      field :slug, :string
    end
  end

  defp slugset(model \\ %Model{}, params) do
    cast(model, params, ~w(), ~w(name slug))
    |> cast_slug
  end

  defp assert_slug(changeset, expected) do
    assert fetch_field(changeset, :slug) == expected
  end

  test "generates slug from source" do
    slugset(%{name: "my name"})
    |> assert_slug({:changes, "my_name"})
  end

  test "slugifies user generated slugs" do
    slugset(%{slug: "my slug"})
    |> assert_slug({:changes, "my_slug"})
  end

  test "changing source field doesn't change slug" do
    slugset(%Model{slug: "a_slug"}, %{name: "meow"})
    |> assert_slug({:model, "a_slug"})
  end

  test "setting slug to nil regenerates from source on model" do
    slugset(%Model{name: "my name", slug: "a_slug"}, %{slug: nil})
    |> assert_slug({:changes, "my_name"})
  end

  test "setting slug to nil regenerates from source on changes" do
    slugset(%Model{name: "my name", slug: "a_slug"}, %{slug: nil, name: "new name"})
    |> assert_slug({:changes, "new_name"})
  end

  test "adds unique constraint" do
    changeset = slugset(%{slug: "foo"})
    assert changeset.constraints == [%{constraint: "models_slug_index", field: :slug,
      message: "has already been taken", type: :unique}]
  end

  test "adds unique constraint with custom optionz" do
    changeset = cast(%Model{}, %{slug: "foo"}, [], [:slug])
    |> cast_slug(constraint_options: [name: :some_pretty_wild_index])
    assert changeset.constraints == [%{constraint: "some_pretty_wild_index", field: :slug,
      message: "has already been taken", type: :unique}]
  end
end
