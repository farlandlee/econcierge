defmodule Grid.Repo.Migrations.CreateItineraries do
  use Ecto.Migration

  def change do
    create table(:shared_carts) do
      add :bookings, :map
      add :uuid, :string

      timestamps
    end

  end
end
