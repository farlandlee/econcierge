defmodule Grid.Repo.Migrations.AddVendorTripadvisorUrl do
  use Ecto.Migration

  def change do
    alter table(:vendors) do
      add :tripadvisor_url, :string
    end
  end
end
