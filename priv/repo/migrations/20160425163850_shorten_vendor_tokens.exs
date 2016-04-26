defmodule Grid.Repo.Migrations.ShortenVendorTokens do
  use Ecto.Migration

  def up do
    execute """
      UPDATE order_items SET
        vendor_token = left(vendor_token, 8);
    """
  end

  def down do
    # irreversible, nothing to do
  end
end
