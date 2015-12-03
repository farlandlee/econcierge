defmodule Grid.Repo.Migrations.CreateVendor do
  use Ecto.Migration

  def change do
    create table(:vendors) do
      add :name, :string
      add :description, :text

      timestamps
    end

  end
end
