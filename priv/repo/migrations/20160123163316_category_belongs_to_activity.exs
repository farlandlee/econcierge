defmodule Grid.Repo.Migrations.CategoryBelongsToActivity do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :activity_id, references(:activities, on_delete: :delete_all)
    end
    create index(:categories, [:activity_id])
    drop unique_index(:categories, [:name])
    create unique_index(:categories, [:name, :activity_id])
  end
end
