defmodule Grid.Amount do
  use Grid.Web, :model

  schema "amounts" do
    field :amount, :float
    field :min_quantity, :integer, default: 0
    field :max_quantity, :integer, default: 0
    belongs_to :price, Grid.Price

    timestamps
  end

  @creation_fields ~w(price_id)
  @required_fields ~w(amount min_quantity max_quantity)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:amount, &(Float.round(&1, 2)))
    |> validate_number(:amount, greater_than_or_equal_to: 0)
    |> validate_number(:max_quantity,
          greater_than_or_equal_to: 0,
          message: "Must be greater than or equal to 0. Set to 0 for no max."
        )
    |> unique_constraint(:max_quantity, [
          name: :amounts_max_quantity_price_id_index,
          message: "Another amount already has the same Max Quantity."
        ])
    |> validate_number(:min_quantity,
          greater_than_or_equal_to: 0,
          message: "Must be greater than or equal to 0. Set to 0 for no minimum."
        )
    |> unique_constraint(:min_quantity, [
          name: :amounts_min_quantity_price_id_index,
          message: "Another amount already has the same Minimum Quantity."
        ])
    |> validate_min_max
  end

  def creation_changeset(params, price_id) do
    %__MODULE__{}
    |> changeset(params)
    |> cast(%{price_id: price_id}, @creation_fields, [])
    |> foreign_key_constraint(:price_id)
  end

  def clone(amount, price_id: price_id) do
    amount
    |> Map.take(__schema__(:fields))
    |> creation_changeset(price_id)
  end

  defp validate_min_max(changeset) do
    min = get_field(changeset, :min_quantity)
    max = get_field(changeset, :max_quantity)

    validate_min_max(changeset, min, max)
  end
  defp validate_min_max(changeset, _, 0), do: changeset
  defp validate_min_max(changeset, min, max) when min > max do
    add_error(changeset, :max_quantity, "Minimum must be less than, or equal to, Maximum.")
  end
  defp validate_min_max(changeset, _, _), do: changeset
end
