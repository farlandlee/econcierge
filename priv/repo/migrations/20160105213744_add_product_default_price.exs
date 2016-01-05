defmodule Grid.Repo.Migrations.AddProductDefaultPrice do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :default_price_id, references(:prices, on_delete: :nilify_all)
    end
    create index(:products, [:default_price_id])
  end
end
