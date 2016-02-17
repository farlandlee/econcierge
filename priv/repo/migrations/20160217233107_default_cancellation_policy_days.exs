defmodule Grid.Repo.Migrations.DefaultCancellationPolicyDays do
  use Ecto.Migration

  def up do
    execute """
      UPDATE vendors SET
        cancellation_policy_days=2
        WHERE cancellation_policy_days is null;
    """

    alter table(:vendors) do
      modify :cancellation_policy_days, :integer, default: 2, null: false
    end
  end
  def down do
    alter table(:vendors) do
      modify :cancellation_policy_days, :integer
    end
  end
end
