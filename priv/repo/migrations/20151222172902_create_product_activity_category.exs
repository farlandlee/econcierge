defmodule Grid.Repo.Migrations.CreateProductActivityCategory do
  use Ecto.Migration

  def change do
    create table(:product_activity_categories) do
      add :activity_category_id, references(:activity_categories, on_delete: :delete_all)
      add :product_id, references(:products, on_delete: :delete_all)

      timestamps
    end
    create index(:product_activity_categories, [:activity_category_id])
    create index(:product_activity_categories, [:product_id])

  end
end
