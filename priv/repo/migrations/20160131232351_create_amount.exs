defmodule Grid.Repo.Migrations.CreateAmount do
  use Ecto.Migration

  def change do
    create table(:amounts) do
      add :amount, :float, null: false
      add :max_quantity, :integer, null: false
      add :price_id, references(:prices, on_delete: :delete_all), null: false

      timestamps
    end
    create index(:amounts, [:price_id])
    create unique_index(:amounts, [:max_quantity, :price_id])

  end
end
