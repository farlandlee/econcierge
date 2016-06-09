defmodule Grid.Repo.Migrations.CreateContentItem do
  use Ecto.Migration

  def change do
    create table(:content_items) do
      add :context, :string
      add :name, :string
      add :content, :text

      timestamps
    end

    create index(:content_items, [:context, :name])
  end
end
