defmodule Grid.Repo.Migrations.AddPeopleToPrice do
  use Ecto.Migration

  def change do
    alter table(:prices) do
      add :people_count, :integer, default: 1
    end
  end
end
