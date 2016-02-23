defmodule Grid.OrderItem do
  use Grid.Web, :model

  schema "order_items" do
    field :amount, :float, nil: false
    field :activity_at, Ecto.DateTime, nil: false
    field :quantities, :map, nil: false
    field :vendor_token, :string, nil: false
    field :vendor_reply_at, Ecto.DateTime, default: nil
    field :status, :string
    belongs_to :order, Grid.Order
    belongs_to :product, Grid.Product

    timestamps
  end

  @required_fields ~w(amount activity_at quantities product_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> maybe_assign_vendor_token
    |> update_change(:amount, &(Float.round(&1, 2)))
    |> validate_number(:amount, greater_than_or_equal_to: 0)
    |> validate_activity_at
    |> validate_quantities
    |> foreign_key_constraint(:order_id)
    |> foreign_key_constraint(:product_id)
  end

  def maybe_assign_vendor_token(changeset) do
    case get_field(changeset, :vendor_token) do
      nil -> put_change(changeset, :vendor_token, UUID.uuid4(:hex))
      _ -> changeset
    end
  end

  #################
  ## Validations ##
  #################

  defp validate_activity_at(changeset) do
    activity_at = get_field(changeset, :activity_at)

    changeset
    |> validate_activity_at(activity_at)
  end
  defp validate_activity_at(changeset, %Ecto.DateTime{} = activity_at) do
    tomorrow = Calendar.DateTime.now!("MST")
      |> Ecto.DateTime.cast!

    case Ecto.DateTime.compare(tomorrow, activity_at) do
      :gt ->
        changeset
        |> add_error(:start_date, "Activity must be on or after tomorrow.")
      _ -> changeset
    end
  end
  defp validate_activity_at(changeset, nil), do: changeset

  defp validate_quantities(changeset) do
    quantities = get_field(changeset, :quantities)

    changeset
    |> validate_quantities(quantities)
  end
  defp validate_quantities(changeset, %{items: items = [_|_]}) do
    changeset
    |> validate_quantity_items(items)
  end
  defp validate_quantities(changeset, _) do
    changeset
    |> add_error(:quantities, "Quantity Map Is Invalid!")
  end

  defp validate_quantity_items(changeset, [hd|tail]) do
    changeset
    |> validate_quantity_item(hd)
    |> validate_quantity_items(tail)
  end
  defp validate_quantity_items(changeset, []), do: changeset
  defp validate_quantity_item(changeset, %{price_id: _, sub_total: _, quantity: _, price_name: _, price_people_count: _}) do
    changeset
  end
  defp validate_quantity_item(changeset, _) do
    changeset
    |> add_error(:quantities, "Quantity Item Is Invalid!")
  end
end
