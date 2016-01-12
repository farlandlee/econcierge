defmodule Grid.Repo.Migrations.MigrateToExperience do
  use Ecto.Migration

  alias Grid.Repo

  defmodule Activity do
    use Grid.Web, :model
    schema "activities" do
      Ecto.Schema.timestamps
    end
  end

  defmodule Experience do
    use Grid.Web, :model
    schema "experiences" do
      field :name, :string
      field :activity_id, :integer

      Ecto.Schema.timestamps
    end
  end

  defmodule Product do
    use Grid.Web, :model
    schema "products" do
      field :name, :string
      field :activity_id, :integer
      field :experience_id, :integer

      Ecto.Schema.timestamps
    end
  end

  def up do
    drop table(:product_activity_categories)
    drop table(:activity_categories)

    products = Repo.all(Product)
    for p <- products do
      {:ok, e} = Repo.insert(%Experience{name: p.name, activity_id: p.activity_id})
      Repo.update!(Ecto.Changeset.change(p, experience_id: e.id))
    end

    alter table(:products) do
      remove :activity_id
    end
  end

  def down do
    create table(:activity_categories) do
      add :activity_id, references(:activities, on_delete: :delete_all)
      add :category_id, references(:categories, on_delete: :delete_all)

      timestamps
    end

    create index(:activity_categories, [:activity_id])
    create index(:activity_categories, [:category_id])

    create table(:product_activity_categories) do
      add :activity_category_id, references(:activity_categories, on_delete: :delete_all)
      add :product_id, references(:products, on_delete: :delete_all)

      timestamps
    end
    create index(:product_activity_categories, [:activity_category_id])
    create index(:product_activity_categories, [:product_id])

    alter table(:products) do
      add :activity_id, references(:activities, delete: :delete_all)
    end
  end
end
