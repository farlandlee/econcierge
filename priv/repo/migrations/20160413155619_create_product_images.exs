defmodule Grid.Repo.Migrations.CreateVendorImage do
  use Ecto.Migration

  def change do
    create table(:product_images) do
      add :filename, :string
      add :alt, :string
      add :original, :string
      add :medium, :string
      add :error, :boolean, default: false
      add :position, :integer

      add :assoc_id, :integer

      timestamps
    end
    create index(:product_images, [:assoc_id])

    alter table(:products) do
      add :default_image_id, references(:product_images, on_delete: :nilify_all)
    end
    create index(:products, [:default_image_id])

    for t <- [:activity_images, :vendor_images] do
      alter table(t) do
        add :position, :integer
      end
    end
  end
end
