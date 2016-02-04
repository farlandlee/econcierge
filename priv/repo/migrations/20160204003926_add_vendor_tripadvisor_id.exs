defmodule Grid.Repo.Migrations.AddVendorTripadvisorId do
  use Ecto.Migration

  def change do
    alter table(:vendors) do
      add :tripadvisor_location_id, :string
    end
  end
end
