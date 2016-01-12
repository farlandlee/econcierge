defmodule Grid.Repo.Migrations.CreateExperienceCategory do
  use Ecto.Migration

  def change do
    create table(:experience_categories) do
      add :experience_id, references(:experiences, on_delete: :delete_all)
      add :category_id, references(:categories, on_delete: :nilify_all)

      timestamps
    end
    create index(:experience_categories, [:experience_id])
    create index(:experience_categories, [:category_id])

  end
end
