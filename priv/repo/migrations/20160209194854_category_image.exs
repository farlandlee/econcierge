defmodule Elixir.Grid.Repo.Migrations.CategoryImage do
  use Ecto.Migration

  def change do
    alter table(:categories) do
      add :image_id, references(:activity_images, on_delete: :nilify_all)
    end
    create index(:categories, [:image_id])
  end
end
