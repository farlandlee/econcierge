defmodule Grid.Repo.Migrations.ChangeShortDescriptionToText do
  use Ecto.Migration

  def change do
    alter table(:products) do
      modify :short_description, :text
    end
  end
end
