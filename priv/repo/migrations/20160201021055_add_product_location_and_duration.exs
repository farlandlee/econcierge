defmodule Grid.Repo.Migrations.AddProductLocationAndDuration do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :meeting_location_id, references(:locations, on_delete: :nilify_all)
      add :duration, :integer, default: 0, null: false
      add :pickup, :boolean, default: true, null: false
    end
  end
end
