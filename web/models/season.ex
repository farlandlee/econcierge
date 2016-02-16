defmodule Grid.Season do
  use Grid.Web, :model

  schema "seasons" do
    field :name,          :string

    field :start_date, Ecto.Date
    field :end_date, Ecto.Date

    belongs_to :vendor_activity, Grid.VendorActivity
    has_many :start_times, Grid.StartTime

    has_one :vendor, through: [:vendor_activity, :vendor]
    has_one :activity, through: [:vendor_activity, :activity]
    has_many :products, through: [:start_times, :product]

    timestamps
  end

  @creation_fields ~w(vendor_activity_id)
  @required_fields ~w(name start_date end_date)
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
    |> validate_date_range
  end

  def creation_changeset(params, assocs) do
    assocs = Enum.into(assocs, %{})
    %__MODULE__{}
    |> changeset(params)
    |> cast(assocs, @creation_fields, [])
    |> foreign_key_constraint(:vendor_activity_id)
  end

  def having_published_products(query \\ __MODULE__) do
    from s in query,
      join: p in assoc(s, :products),
      where: p.published == true, distinct: true
  end

  def first_from_date(query \\ __MODULE__, _)
  def first_from_date(query, date) do
    from s in query,
      where: s.end_date >= ^date,
      order_by: [s.start_date],
      limit: 1
  end

  #################
  ## Validations ##
  #################

  defp validate_date_range(changeset) do
    start_date = get_field(changeset, :start_date)
    end_date = get_field(changeset, :end_date)
    compare_dates(changeset, start_date, end_date)
  end

  defp compare_dates(changeset, start_date, end_date) when not is_nil(start_date) and not is_nil(end_date) do
    case Ecto.Date.compare(start_date, end_date) do
      :gt ->
        changeset
        |> add_error(:start_date, "Start date must be on or before end date.")
        |> add_error(:end_date, "End date must be on or after start date.")
      _ -> changeset
    end
  end
  defp compare_dates(changeset, _, _), do: changeset
end
