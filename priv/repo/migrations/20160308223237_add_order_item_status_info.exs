defmodule Grid.Repo.Migrations.AddOrderItemStatusInfo do
  use Ecto.Migration

  def change do
    alter table(:order_items) do
      add :status_info, :map
    end
  end
end
