defmodule Grid.Repo.Migrations.ChangeToStripeId do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :stripe_id, :string
      remove :stripe_token
    end
  end
end
