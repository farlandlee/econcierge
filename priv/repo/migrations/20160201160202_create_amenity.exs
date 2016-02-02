defmodule Grid.Repo.Migrations.CreateAmenity do
  use Ecto.Migration

  def change do
    create table(:amenities) do
      add :activity_id, references(:activities, on_delete: :delete_all), null: false
      add :name, :string, null: false

      timestamps
    end
    create index(:amenities, [:activity_id])

  end
end
