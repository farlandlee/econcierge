defmodule Grid.Product do
  use Grid.Web, :model

  schema "products" do
    field :description, :string
    field :name, :string
    field :published, :boolean, default: :false

    belongs_to :vendor, Grid.Vendor
    belongs_to :experience, Grid.Experience
    belongs_to :default_price, Grid.Price

    has_many :prices, Grid.Price
    has_many :start_times, Grid.StartTime

    has_many :categories, through: [:experience, :experience_categories, :category]
    has_one :activity, through: [:experience, :activity]

    timestamps
  end

  @required_fields ~w(description name published vendor_id)
  @optional_fields ~w(experience_id)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> foreign_key_constraint(:vendor_id)
    |> foreign_key_constraint(:experience_id)
    |> foreign_key_constraint(:default_price_id)
    |> update_change(:name, &String.strip/1)
    |> update_change(:description, &String.strip/1)
    |> validate_length(:name, min: 1, max: 255)
    |> validate_length(:description, min: 1, max: 255)
  end

  @copyable_fields ~w(description name vendor_id experience_id)a
  def clone(product) do
    fields = product |> Map.take(@copyable_fields)
    Map.merge(%__MODULE__{}, fields)
  end
end
