defmodule Grid.Repo.Migrations.SetSlugs do
  use Ecto.Migration

  alias Grid.Repo

  @table_modules [
    {"activities", Activity},
    {"categories", Category},
    {"vendors", Vendor}
  ]

  # Fake modules to make slugifying time-proof
  for {table, module} <- @table_modules do
    defmodule module do
      use Grid.Web, :model
      schema table do
        field :name, :string
        field :slug, :string

        Ecto.Schema.timestamps
      end
    end
  end

  def change do
    migration = case direction do
      :up -> &Grid.Models.Slug.cast_slug/1
      :down -> &(Ecto.Changeset.change(&1, slug: nil))
    end
    for table <- @table_modules do
      Enum.map(Repo.all(table), fn model ->
        model
        |> Ecto.Changeset.change
        |> migration.()
        |> Repo.update!
      end)
    end
  end
end
