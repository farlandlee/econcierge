defmodule Grid.Repo.Migrations.AddCouponToOrder do
  use Ecto.Migration

  def change do
    alter table(:orders) do
      add :coupon_id, references(:coupons)
      add :coupon, :map
    end
    create index(:orders, [:coupon_id])
  end
end
