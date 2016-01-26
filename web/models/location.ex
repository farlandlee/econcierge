defmodule Grid.Location do
  use Grid.Web, :model

  schema "locations" do
    field :name, :string
    field :address1, :string
    field :address2, :string
    field :city, :string
    field :state, :string
    field :zip, :string
    belongs_to :vendor, Grid.Vendor

    timestamps
  end

  @creation_fields ~w(vendor_id)
  @required_fields ~w(name address1 city state zip)
  @optional_fields ~w(address2)

  @state_codes Grid.USStates.codes()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> update_change(:name, &String.strip/1)
    |> update_change(:address1, &String.strip/1)
    |> update_change(:address2, &String.strip/1)
    |> update_change(:city, &String.strip/1)
    |> update_change(:zip, &String.strip/1)
    |> validate_length(:name, min: 1, max: 255)
    |> validate_length(:address1, min: 1, max: 255)
    |> validate_length(:address2, min: 1, max: 255)
    |> validate_length(:city, min: 1, max: 255)
    |> validate_length(:zip, min: 1, max: 255)
    |> validate_inclusion(:state, @state_codes, message: "is not a recognized two-letter state code")
  end

  def creation_changeset(params, vendor_id) do
    %__MODULE__{}
    |> changeset(params)
    |> cast(%{vendor_id: vendor_id}, @creation_fields, [])
    |> foreign_key_constraint(:vendor_id)
  end
end
