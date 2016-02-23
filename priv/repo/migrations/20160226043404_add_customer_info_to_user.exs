defmodule Grid.Repo.Migrations.AddCustomerInfoToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :phone, :string
      add :stripe_token, :string
    end
  end
end
