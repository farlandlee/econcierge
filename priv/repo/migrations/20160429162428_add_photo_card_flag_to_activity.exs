defmodule Grid.Repo.Migrations.AddPhotoCardFlagToActivity do
  use Ecto.Migration

  def change do
    alter table(:activities) do
      add :use_product_photo_card, :boolean, default: false
    end
  end
end
