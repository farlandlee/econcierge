defmodule Grid.Repo.Migrations.AddChargeIdToOrderItem do
  use Ecto.Migration

  def change do
    alter table(:order_items) do
      add :stripe_charge_id, :string
      add :charged_at, :datetime
    end
  end
end
