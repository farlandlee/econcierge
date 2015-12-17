defmodule Grid.Repo.Migrations.CreateVendorImage do
  use Ecto.Migration

  def change do
    create table(:vendor_images) do
      add :filename, :string
      add :alt, :string
      add :original, :string
      add :medium, :string

      add :assoc_id, :integer

      timestamps
    end
    create index(:vendor_images, [:assoc_id])

  end
end
