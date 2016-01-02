defmodule Grid.Repo.Migrations.SetSlugs do
  use Ecto.Migration

  alias Grid.Repo
  alias Grid.Activity
  alias Grid.Category
  alias Grid.Product
  alias Grid.Vendor

  def change do
    migration = case direction do
      :up -> &Grid.Models.Utils.slugify/1
      :down -> &(Ecto.Changeset.change(&1, slug: nil))
    end
    for m <- [Activity, Category, Vendor] do
      Enum.map(Repo.all(m), fn model ->
        model
        |> Ecto.Changeset.change
        |> migration.()
        |> Repo.update!
      end)
    end
  end
end
