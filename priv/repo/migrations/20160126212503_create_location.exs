defmodule Grid.Repo.Migrations.CreateLocation do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :name, :string
      add :address1, :string
      add :address2, :string
      add :city, :string
      add :state, :string
      add :zip, :string
      add :vendor_id, references(:vendors, on_delete: :delete_all), null: false

      timestamps
    end
    create index(:locations, [:vendor_id])

  end
end
