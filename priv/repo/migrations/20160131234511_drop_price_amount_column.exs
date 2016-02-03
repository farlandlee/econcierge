defmodule Grid.Repo.Migrations.DropPriceAmountColumn do
  use Ecto.Migration

  def up do
    alter table(:prices) do
      remove :amount
    end
  end
  def down do
    alter table(:prices) do
      add :amount, :float
    end
  end
end
