defmodule Grid.Repo.Migrations.StartTimeSeason do
  use Ecto.Migration

  def change do
    alter table(:start_times) do
      add :season_id, references(:seasons, on_delete: :delete_all)
    end
  end
end
