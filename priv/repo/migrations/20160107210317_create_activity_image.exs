defmodule Grid.Repo.Migrations.CreateActivityImage do
  use Ecto.Migration

  def change do
    create table(:activity_images) do
      add :filename, :string
      add :alt, :string
      add :original, :string
      add :medium, :string

      add :assoc_id, :integer

      timestamps
    end
    create index(:activity_images, [:assoc_id])
  end
end
