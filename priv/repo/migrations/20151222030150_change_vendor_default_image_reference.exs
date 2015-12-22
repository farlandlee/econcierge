defmodule Grid.Repo.Migrations.ChangeVendorDefaultImageReference do
  use Ecto.Migration

  def change do
    alter table(:vendors) do
      remove :default_image_id
      add :default_image_id, references(:vendor_images, on_delete: :nilify_all)
    end
  end
end
