defmodule Grid.Repo.Migrations.AddProductPublishFlag do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :published, :boolean
    end
  end
end
