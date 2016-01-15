defmodule Grid.Repo.Migrations.CreateExperience do
  use Ecto.Migration

  def change do
    create table(:experiences) do
      add :name, :string
      add :description, :text
      add :slug, :text
      add :activity_id, references(:activities, on_delete: :delete_all)
      add :image_id, references(:activity_images, on_delete: :nilify_all)

      timestamps
    end
    create index(:experiences, [:activity_id])
    create index(:experiences, [:image_id])
    create unique_index(:experiences, [:slug])
    create unique_index(:experiences, [:name])

    alter table(:products) do
      add :experience_id, references(:experiences, on_delete: :delete_all)
    end
  end
end
