defmodule Grid.Repo.Migrations.AddVendorTripadvisorRating do
  use Ecto.Migration

  def change do
    alter table(:vendors) do
      add :tripadvisor_rating, :float
      add :tripadvisor_rating_image_url, :string
      add :tripadvisor_reviews_count, :integer
    end
  end
end
