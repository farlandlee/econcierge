defmodule Grid.Repo.Migrations.CreateVendorActivity do
  use Ecto.Migration

  def change do
    create table(:vendor_activity_types) do
      add :vendor_id, references(:vendors, on_delete: :delete_all)
      add :activity_type_id, references(:activity_types, on_delete: :delete_all)

      timestamps
    end
    create index(:vendor_activity_types, [:vendor_id])
    create index(:vendor_activity_types, [:activity_type_id])
  end
end
