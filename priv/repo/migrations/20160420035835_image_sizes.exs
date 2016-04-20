defmodule Grid.Repo.Migrations.ImageSizes do
  use Ecto.Migration

  def change do
    for t <- [:activity_images, :vendor_images, :product_images] do
      alter table(t) do
        add :large, :string
        add :thumb, :string
      end
    end
  end
end
