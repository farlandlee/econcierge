defmodule Grid.Repo.Migrations.AddCategoryDefaultExperience do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :default_experience_id, references(:experiences, on_delete: :nilify_all)
    end
  end
end
