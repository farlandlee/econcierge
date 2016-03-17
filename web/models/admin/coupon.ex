defmodule Grid.Coupon do
  use Grid.Web, :model

  schema "coupons" do
    field :code, :string
    field :percent_off, :integer
    field :usage_count, :integer, default: 0
    field :max_usage_count, :integer
    field :expiration_date, Ecto.Date, default: %Ecto.Date{year: 2016, month: 12, day: 31}
    field :disabled, :boolean, default: false

    timestamps
  end

  def normalize_code(code) do
    code
    |> String.upcase
    |> String.replace(" ", "_")
  end

  def valid?(%{max_usage_count: max, usage_count: uses, expiration_date: expiry}) do
    today = "MST" |> Calendar.DateTime.now! |> Ecto.Date.cast!
    cond do
      Ecto.Date.compare(expiry, today) == :lt -> false
      max && uses >= max -> false
      :valid -> true
    end
  end

  def to_map(%__MODULE__{} = coupon) do
    coupon |> Map.take([:id, :code, :percent_off, :expiration_date])
  end

  def increment_usage(coupon) do
    from c in __MODULE__,
      where: c.id == ^coupon.id,
      update: [inc: [usage_count: 1]]
  end

  @required_fields ~w(code percent_off expiration_date)
  @optional_fields ~w(disabled max_usage_count)


  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:code)
    |> validate_length(:code, min: 5)
    |> update_change(:code, &normalize_code/1)
    |> validate_format(:code, ~r/^([A-Z0-9_]+)$/, message: "can only contain letters, numbers, and underscores. spaces are automatically converted")
    |> validate_number(:max_usage_count, greater_than: 0)
    |> validate_number(:percent_off, greater_than: 0, less_than_or_equal_to: 100)
  end
end
