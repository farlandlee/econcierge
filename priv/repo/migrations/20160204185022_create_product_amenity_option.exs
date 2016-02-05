defmodule Grid.Repo.Migrations.CreateProductAmenityOption do
  use Ecto.Migration

  def change do
    create table(:product_amenity_options) do
      add :product_id, references(:products, on_delete: :delete_all), null: false
      add :amenity_option_id, references(:amenity_options, on_delete: :delete_all), null: false

      timestamps
    end
    create index(:product_amenity_options, [:product_id])
    create index(:product_amenity_options, [:amenity_option_id])

    create unique_index(:product_amenity_options, [:product_id, :amenity_option_id])

  end
end
