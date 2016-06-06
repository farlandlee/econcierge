defmodule Grid.Kiosk do
  use Grid.Web, :model

  schema "kiosks" do
    field :name, :string
    field :sub_domain, :string

    has_many :kiosk_sponsors, Grid.KioskSponsor
    has_many :vendors, through: [:kiosk_sponsors, :vendor]
    has_many :vendor_activities, through: [:kiosk_sponsors, :vendor, :vendor_activities]

    has_many :kiosk_slides, Grid.KioskSlide
    has_many :slides, through: [:kiosk_slides, :slide]

    timestamps
  end

  @required_fields ~w(name sub_domain)
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
    |> update_change(:sub_domain, &String.downcase/1)
    |> update_change(:sub_domain, &(String.replace(&1, ~r/[^a-z0-9\/-]+/, "")))
    |> validate_length(:sub_domain, min: 1, max: 255)
  end
end
