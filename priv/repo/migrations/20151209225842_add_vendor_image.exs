defmodule Grid.Repo.Migrations.AddVendorImage do
  use Ecto.Migration

  def change do
    alter table(:vendors) do
      add :default_image_id, references(:images, on_delete: :nilify_all)
    end
  end
end
