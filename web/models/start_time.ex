defmodule Grid.StartTime do
  use Grid.Web, :model

  schema "start_times" do
    field :starts_at_time, Ecto.Time

    belongs_to :product,   Grid.Product
    belongs_to :season,    Grid.Season

    timestamps
  end

  @creation_fields ~w(product_id season_id)
  @required_fields ~w(starts_at_time)
  @optional_fields ~w(season_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  def creation_changeset(params, assocs) do
    assocs = Enum.into(assocs, %{})
    %__MODULE__{}
    |> changeset(params)
    |> cast(assocs, @creation_fields, [])
    |> foreign_key_constraint(:product_id)
  end

  def clone(start_time, assocs) do
    start_time
    |> Map.take(__schema__(:fields))
    |> creation_changeset(assocs)
  end
end
