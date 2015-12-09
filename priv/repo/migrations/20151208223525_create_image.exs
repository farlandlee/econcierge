defmodule Grid.Repo.Migrations.CreateImage do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :filename, :string
      add :alt, :string
      add :original, :string
      add :medium, :string

      timestamps
    end
  end
end
