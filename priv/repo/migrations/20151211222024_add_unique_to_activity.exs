defmodule :"Elixir.Grid.Repo.Migrations.Add-unique-to-activity" do
  use Ecto.Migration

  def change do
    create unique_index(:activities, [:name])
  end
end
