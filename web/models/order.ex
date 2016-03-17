defmodule Grid.Order do
  use Grid.Web, :model

  alias Grid.{
    Coupon,
    OrderItem
  }

  schema "orders" do
    field :total_amount, :float
    field :customer_token, :string
    field :coupon_id, :integer
    field :coupon, :map
    belongs_to :user, Grid.User

    has_many :order_items, OrderItem

    timestamps
  end

  @required_fields ~w(total_amount)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:total_amount, &(Float.round(&1, 2)))
    |> validate_number(:total_amount, greater_than_or_equal_to: 0)
  end

  @required_creation_fields ~w(user_id customer_token)
  @optional_creation_fields ~w(coupon_id coupon)
  @doc """
  - **relationships** :user_id required, :coupon optional
  """
  def creation_changeset(params, relationships) do
    customer_token = UUID.uuid4(:hex) |> String.slice(0..7)
    user_id = relationships[:user_id]
    coupon = if c = relationships[:coupon], do: Coupon.to_map(c)
    coupon_id = if coupon, do: coupon.id

    creation_params = %{
      user_id: user_id,
      coupon: coupon,
      coupon_id: coupon_id,
      customer_token: customer_token
    }

    %__MODULE__{}
    |> changeset(params)
    |> cast(creation_params, @required_creation_fields, @optional_creation_fields)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:coupon_id)
    |> cast_assoc(:order_items, required: true)
  end
end
