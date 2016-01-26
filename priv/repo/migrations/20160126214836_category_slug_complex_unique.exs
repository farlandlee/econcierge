defmodule Grid.Repo.Migrations.CategorySlugComplexUnique do
  use Ecto.Migration

  def change do
    drop unique_index(:categories, [:slug])
    create unique_index(:categories, [:slug, :activity_id])
  end
end
