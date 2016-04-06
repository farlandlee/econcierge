defmodule Grid.Repo.Migrations.PopulateAmountCharged do
  use Ecto.Migration

  def up do
    execute """
      UPDATE order_items SET
        amount_charged = amount
        WHERE status = 'accepted' AND amount_charged = 0.0;
    """
  end
end
