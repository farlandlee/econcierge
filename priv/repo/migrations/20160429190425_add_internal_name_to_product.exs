defmodule Grid.Repo.Migrations.AddInternalNameToVendor do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :internal_name, :string
    end
  end
end
