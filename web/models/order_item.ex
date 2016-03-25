defmodule Grid.OrderItem do
  use Grid.Web, :model

  schema "order_items" do
    field :amount, :float, nil: false
    field :amount_charged, :float, nil: false, default: 0.0
    field :activity_at, Ecto.DateTime, nil: false
    field :quantities, :map, nil: false
    field :vendor_token, :string, nil: false
    field :vendor_reply_at, Ecto.DateTime, default: nil
    field :status, :string
    field :status_info, :map
    field :stripe_charge_id, :string
    field :charged_at, Ecto.DateTime, default: nil
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

  def status_changeset(model, :accept) do
    do_status_changeset(model, "accepted")
  end

  def status_changeset(model, :reject) do
    do_status_changeset(model, "rejected")
  end

  defp do_status_changeset(model, status) do
    params = %{
      status: status,
      status_info: nil,
      vendor_reply_at: Calendar.DateTime.now_utc
    }
    cast(model, params, [:status, :vendor_reply_at], [:status_info])
  end

  def error_changeset(model, error) do
    params = %{status: "errored", status_info: error}
    cast(model, params, [:status, :status_info], [])
  end

  @charge_changeset_params ~w(stripe_charge_id charged_at amount_charged)a
  def charge_changeset(model, charge_id, amount_charged) do
    params = %{
      stripe_charge_id: charge_id,
      charged_at: Calendar.DateTime.now_utc,
      amount_charged: amount_charged
    }
    cast(model, params, @charge_changeset_params, [])
  end

  #######################
  ## Changeset Helpers ##
  #######################

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
    case get_field(changeset, :activity_at) do
      nil ->
        changeset
      activity_at ->
        do_validate_activity_at(changeset, activity_at)
    end
  end

  defp do_validate_activity_at(changeset, activity_at) do
    tomorrow = Calendar.DateTime.now!("MST")
      |> Ecto.DateTime.cast!

    case Ecto.DateTime.compare(tomorrow, activity_at) do
      :gt ->
        add_error(changeset, :start_date, "Activity must be on or after tomorrow.")
      _ ->
        changeset
    end
  end

  defp validate_quantities(changeset) do
    case get_field(changeset, :quantities) do
      %{"items" => items = [_|_]} ->
        Enum.reduce(items, changeset, &validate_quantity_item/2)
      _ ->
        add_error(changeset, :quantities, "Quantity Map Is Invalid!")
    end
  end

  @required_item_keys ~w(price_id sub_total quantity price_name price_people_count)
  defp validate_quantity_item(quantity_item, changeset) do
    valid = @required_item_keys |> Enum.all?(&Map.has_key?(quantity_item, &1))
    if valid do
      changeset
    else
      add_error(changeset, :quantities, "Quantity Item Is Invalid!")
    end
  end

end
