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

  @creation_fields ~w(vendor_id experience_id)a
  @required_fields ~w(description name published)a
  @optional_fields ~w(experience_id)a

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
    |> update_change(:description, &String.strip/1)
    |> validate_length(:description, min: 1, max: 255)
    |> foreign_key_constraint(:experience_id)
  end

  def default_price_changeset(model, default_price_id) do
    model
    |> cast(%{default_price_id: default_price_id}, [:default_price_id], [])
    |> foreign_key_constraint(:default_price_id)
  end

  def creation_changeset(params, vendor_id) do
    %__MODULE__{}
    |> changeset(params)
    |> cast(%{vendor_id: vendor_id}, @creation_fields, [])
    |> foreign_key_constraint(:vendor_id)
  end

  def clone(product) do
    product
    |> Map.take(__schema__(:fields))
    |> creation_changeset(product.vendor_id)
    |> put_change(:name, "#{product.name} Clone")
    |> put_change(:published, false)
  end
end
