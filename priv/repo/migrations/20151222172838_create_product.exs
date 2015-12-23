defmodule Grid.Repo.Migrations.CreateProduct do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :description, :string
      add :name, :string
      add :vendor_id, references(:vendors, on_delete: :delete_all)
      add :activity_id, references(:activities, on_delete: :nilify_all)

      timestamps
    end
    create index(:products, [:vendor_id])
    create index(:products, [:activity_id])

  end
end
