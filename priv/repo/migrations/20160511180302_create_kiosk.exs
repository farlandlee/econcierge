defmodule Grid.Repo.Migrations.CreateKiosk do
  use Ecto.Migration

  def change do
    create table(:kiosks) do
      add :name, :string, null: false
      add :sub_domain, :string, null: false

      timestamps
    end

  end
end
