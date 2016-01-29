defmodule Grid.StartTime do
  use Grid.Web, :model

  schema "start_times" do
    field :starts_at_time, Ecto.Time
    belongs_to :product, Grid.Product

    timestamps
  end

  @creation_fields ~w(product_id)
  @required_fields ~w(starts_at_time)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def creation_changeset(params, product_id) do
    %__MODULE__{}
    |> changeset(params)
    |> cast(%{product_id: product_id}, @creation_fields, [])
    |> foreign_key_constraint(:product_id)
  end

  def clone(start_time, product_id: product_id) do
    start_time
    |> Map.take(__schema__(:fields))
    |> creation_changeset(product_id)
  end
end
