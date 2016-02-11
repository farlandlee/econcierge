defmodule Grid.Repo.Migrations.ChangeProductDescriptionToText do
  use Ecto.Migration

  def up do
    alter table(:products) do
      modify :description, :text, null: false
    end
  end

  def down do
    alter table(:products) do
      modify :description, :string
    end
  end
end
