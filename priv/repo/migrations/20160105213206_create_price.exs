defmodule Grid.Repo.Migrations.CreatePrice do
  use Ecto.Migration

  def change do
    create table(:prices) do
      add :amount, :float
      add :name, :string
      add :description, :string
      add :product_id, references(:products, on_delete: :delete_all)

      timestamps
    end
    create index(:prices, [:product_id])

  end
end
