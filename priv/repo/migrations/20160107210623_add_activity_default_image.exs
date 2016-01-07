defmodule Grid.Repo.Migrations.AddActivityDefaultImage do
  use Ecto.Migration

  def change do
    alter table(:activities) do
      add :default_image_id, references(:activity_images, on_delete: :nilify_all)
    end
    create index(:activities, [:default_image_id])
  end
end
