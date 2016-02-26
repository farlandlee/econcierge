defmodule Grid.Repo.Migrations.CreateOrderItem do
  use Ecto.Migration

  def change do
    create table(:order_items) do
      add :amount, :float
      add :activity_at, :datetime
      add :vendor_reply_at, :datetime
      add :status, :string
      add :quantities, :map
      add :vendor_token, :string
      add :order_id, references(:orders, on_delete: :nothing)
      add :product_id, references(:products, on_delete: :nothing)

      timestamps
    end
    create index(:order_items, [:order_id])
    create index(:order_items, [:product_id])
  end
end
