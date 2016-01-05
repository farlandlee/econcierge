defmodule Grid.Repo.Migrations.CreateStartTime do
  use Ecto.Migration

  def change do
    create table(:start_times) do
      add :starts_at_time, :time
      add :product_id, references(:products)

      timestamps
    end
    create index(:start_times, [:product_id])

  end
end
