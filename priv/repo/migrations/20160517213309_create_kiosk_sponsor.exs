defmodule Grid.Repo.Migrations.CreateKioskSponsor do
  use Ecto.Migration

  def change do
    create table(:kiosk_sponsors) do
      add :kiosk_id, references(:kiosks, on_delete: :delete_all)
      add :vendor_id, references(:vendors, on_delete: :delete_all)

      timestamps
    end
    create index(:kiosk_sponsors, [:kiosk_id])
    create index(:kiosk_sponsors, [:vendor_id])

  end
end
