defmodule Grid.Repo.Migrations.ChangeSlugsToStrings do
  use Ecto.Migration

  @tables ~w(activities categories vendors experiences)a
  def up do
    for t <- @tables do
      alter table(t) do
        modify :slug, :string, null: false
      end
    end
  end

  def down do
    for t <- @tables do
      alter table(t) do
        modify :slug, :text
      end
    end
  end
end
