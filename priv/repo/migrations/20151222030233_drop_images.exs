defmodule Grid.Repo.Migrations.DropImages do
  use Ecto.Migration

  def change do
    drop table(:images)
  end
end
