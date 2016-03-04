defmodule Grid.Repo.Migrations.AddWebsitePhoneToVendor do
  use Ecto.Migration

  def change do
    alter table(:vendors) do
      add :website, :string
      add :telephone, :string
    end
  end
end
