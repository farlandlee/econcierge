defmodule Grid.Repo.Migrations.ImageError do
  use Ecto.Migration

  def change do
    for t <- [:activity_images, :vendor_images] do
      alter table(t) do
        add :error, :boolean, default: false
      end
    end
  end
end
