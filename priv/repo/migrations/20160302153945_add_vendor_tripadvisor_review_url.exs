defmodule Grid.Repo.Migrations.AddVendorTripadvisorReviewUrl do
  use Ecto.Migration

  def change do
    alter table(:vendors) do
      add :tripadvisor_review_url, :string
    end
  end
end
