defmodule Grid.Repo.Migrations.AddNameToSlide do
  use Ecto.Migration

  def up do
    alter table(:slides) do
      add :name, :string
    end

    # We need to set the name to something.
    execute """
      update slides set name = id
    """

    alter table(:slides) do
      modify :name, :string, null: false
    end
  end

  def down do
    alter table(:slides) do
      remove :name
    end
  end
end
