defmodule Grid.Repo.Migrations.UpdateVendor do
  use Ecto.Migration

  def change do
    alter table(:vendors) do
      add :notification_email, :string
      add :cancellation_policy_days, :integer
      add :admin_notes, :text
    end
  end
end
