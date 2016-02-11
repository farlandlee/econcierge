defmodule Grid.Repo.Migrations.UpdateAmountAddMinQuantity do
  use Ecto.Migration

  def change do
    alter table(:amounts) do
      add :min_quantity, :integer, null: false, default: 0
    end

    create unique_index(:amounts, [:min_quantity, :price_id])
  end
end
