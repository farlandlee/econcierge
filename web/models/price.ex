defmodule Grid.Price do
  use Grid.Web, :model

  schema "prices" do
    field :name, :string
    field :description, :string
    field :people_count, :integer, default: 1
    belongs_to :product, Grid.Product

    has_many :amounts, Grid.Amount

    timestamps
  end

  @required_fields ~w(name people_count)
  @optional_fields ~w(description)
  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:name, &String.strip/1)
    |> update_change(:description, &String.strip/1)
    |> validate_length(:name, min: 1, max: 255)
    |> validate_length(:description, min: 1, max: 255)
    |> validate_number(:people_count, greater_than_or_equal_to: 0)
  end

  def creation_changeset(params, product_id) do
    %__MODULE__{}
    |> changeset(params)
    |> cast(%{product_id: product_id}, [:product_id], [])
    |> foreign_key_constraint(:product_id)
  end

  def clone(price, product_id: product_id) do
    price
    |> Map.take(__schema__(:fields))
    |> creation_changeset(product_id)
  end
end
