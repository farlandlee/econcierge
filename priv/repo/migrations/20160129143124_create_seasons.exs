defmodule Grid.Repo.Migrations.CreateSeason do
  use Ecto.Migration

  def change do
    create table(:seasons) do
      add :name,       :string, null: :false

      add :start_date_day, :integer, null: :false
      add :start_date_month, :integer, null: :false
      add :end_date_day, :integer, null: :false
      add :end_date_month, :integer, null: :false

      add :vendor_activity_id, references(:vendor_activities, on_delete: :delete_all), null: :false

      timestamps
    end

    create index(:seasons, [:vendor_activity_id])
  end
end
