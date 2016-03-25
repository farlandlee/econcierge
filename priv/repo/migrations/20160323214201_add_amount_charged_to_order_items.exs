defmodule Grid.Repo.Migrations.AddAmountChargedToOrderItems do
  use Ecto.Migration

  def change do
    alter table(:order_items) do
      add :amount_charged, :float, nil: false, default: 0.0
    end
  end
end
