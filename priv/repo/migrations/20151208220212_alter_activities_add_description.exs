defmodule Grid.Repo.Migrations.AlterActivitiesAddDescription do
  use Ecto.Migration

  def change do
    alter table(:activities) do
      add :description, :text
    end
  end
end
