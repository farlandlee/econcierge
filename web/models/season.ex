defmodule Grid.Season do
  use Grid.Web, :model

  schema "seasons" do
    field :name,          :string

    field :end_date_month,    :integer
    field :end_date_day,      :integer

    field :start_date_month,  :integer
    field :start_date_day,    :integer

    belongs_to :vendor_activity, Grid.VendorActivity

    has_one :vendor, through: [:vendor_activity, :vendor]
    has_one :activity, through: [:vendor_activity, :activity]

    timestamps
  end

  @creation_fields ~w(vendor_activity_id)
  @required_fields ~w(name start_date_month start_date_day end_date_month end_date_day)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:name, &String.strip/1)
    |> validate_length(:name, min: 1, max: 255)
    |> validate_number(:start_date_month, greater_than: 0, less_than: 13)
    |> validate_number(:end_date_month, greater_than: 0, less_than: 13)
    |> validate_number(:start_date_day, greater_than: 0, less_than: 32)
    |> validate_number(:end_date_day, greater_than: 0, less_than: 32)
  end

  def creation_changeset(params, assocs) do
    assocs = Enum.into(assocs, %{})
    %__MODULE__{}
    |> changeset(params)
    |> cast(assocs, @creation_fields, [])
    |> foreign_key_constraint(:vendor_activity_id)
  end
end
