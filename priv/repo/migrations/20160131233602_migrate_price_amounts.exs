defmodule Price do
  use Grid.Web, :model
  schema "prices" do
    field :amount, :float
  end
end
defmodule Amount do
  use Grid.Web, :model
  schema "amounts" do
    field :amount, :float
    field :max_quantity, :integer
    belongs_to :price, Price
    timestamps
  end
end

defmodule Grid.Repo.Migrations.MigratePriceAmounts do
  use Ecto.Migration

  import Ecto.Query

  alias Grid.Repo

  def up do
    for price <- Repo.all(Price) do
      %Amount{
        price_id: price.id,
        amount: price.amount,
        max_quantity: 0
      } |> Repo.insert!
    end
  end

  def down do
    for amount <- Repo.all(Amount) do
      from(p in Price,
      where: p.id == ^amount.price_id,
      update: [set: [amount: ^amount.amount]])
      |> Repo.update_all([])
    end
  end
end
