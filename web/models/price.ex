defmodule Grid.Price do
  use Grid.Web, :model

  schema "prices" do
    field :amount, :float
    field :name, :string
    field :description, :string
    belongs_to :product, Grid.Product

    timestamps
  end

  @required_fields ~w(amount name)
  @optional_fields ~w(description)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:amount, &(Float.round(&1, 2)))
    |> update_change(:name, &String.strip/1)
    |> update_change(:description, &String.strip/1)
    |> validate_length(:name, min: 1, max: 255)
    |> validate_length(:description, min: 1, max: 255)
  end
end
