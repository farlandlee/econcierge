defmodule Grid.Repo.Migrations.AddSlugs do
  use Ecto.Migration

  def change do
    for t <- [:activities, :categories, :vendors] do
      alter table(t) do
        add :slug, :text
      end
      create unique_index(t, [:slug])

    end
  end
end
