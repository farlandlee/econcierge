defmodule Grid.Repo.Migrations.AddStartTimeDayFields do
  use Ecto.Migration

  def change do
    alter table(:start_times) do
      for day <- ~w(monday tuesday wednesday thursday friday saturday sunday)a do
        add day, :boolean, default: true, null: false
      end
    end
  end
end
