defmodule Grid.Order do
  use Grid.Web, :model

  alias Grid.OrderItem

  schema "orders" do
    field :total_amount, :float
    field :customer_token, :string
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

  @creation_fields ~w(user_id customer_token)
  def creation_changeset(params, user_id) do
    customer_token = UUID.uuid4(:hex) |> String.slice(0..7)

    %__MODULE__{}
    |> changeset(params)
    |> cast(%{user_id: user_id, customer_token: customer_token}, @creation_fields, [])
    |> foreign_key_constraint(:user_id)
    |> cast_assoc(:order_items, required: true)
  end
end
