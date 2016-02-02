defmodule Grid.Repo.Migrations.CreateAmenityOption do
  use Ecto.Migration

  def change do
    create table(:amenity_options) do
      add :amenity_id, references(:amenities, on_delete: :delete_all), null: false
      add :name, :string, null: false

      timestamps
    end
    create index(:amenity_options, [:amenity_id])

  end
end
