defmodule Grid.Repo.Migrations.CreateActivityType do
  use Ecto.Migration

  def change do
    create table(:activity_types) do
      add :name, :string

      timestamps
    end

  end
end
