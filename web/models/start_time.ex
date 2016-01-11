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
  end
end