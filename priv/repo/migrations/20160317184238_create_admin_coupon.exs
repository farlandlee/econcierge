defmodule Grid.Repo.Migrations.CreateAdmin.Coupon do
  use Ecto.Migration

  def change do
    create table(:coupons) do
      add :code, :string, null: false
      add :percent_off, :integer, null: false
      add :expiration_date, :date, null: false
      add :usage_count, :integer, default: 0, null: false
      add :max_usage_count, :integer
      add :disabled, :boolean, default: false

      timestamps
    end
    create unique_index(:coupons, [:code])
  end
end
