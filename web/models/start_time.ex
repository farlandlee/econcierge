defmodule Grid.StartTime do
  use Grid.Web, :model

  schema "start_times" do
    field :starts_at_time, Ecto.Time
    belongs_to :product, Grid.Product

    timestamps
  end

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
    |> foreign_key_constraint(:product_id)
  end

  @copyable_fields ~w(starts_at_time)a
  def clone(start_time, product_id: product_id) do
    fields = start_time
      |> Map.take(@copyable_fields)
      |> Map.put(:product_id, product_id)
    Map.merge(%__MODULE__{}, fields)
  end
end
