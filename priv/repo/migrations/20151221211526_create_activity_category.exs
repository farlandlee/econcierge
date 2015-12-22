defmodule Grid.Repo.Migrations.CreateActivityCategory do
  use Ecto.Migration

  def change do
    create table(:activity_categories) do
      add :activity_id, references(:activities, on_delete: :delete_all)
      add :category_id, references(:categories, on_delete: :delete_all)

      timestamps
    end

    create index(:activity_categories, [:activity_id])
    create index(:activity_categories, [:category_id])
  end
end
