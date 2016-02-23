defmodule Grid.Repo.Migrations.CreateOrder do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :total_amount, :float, nil: false
      add :customer_token, :string, nil: false
      add :user_id, references(:users, on_delete: :nothing)

      timestamps
    end
    create index(:orders, [:user_id])

  end
end
