defmodule Grid.Product do
  use Grid.Web, :model

  schema "products" do
    field :description, :string
    field :name, :string
    field :published, :boolean, default: false
    field :pickup, :boolean, default: true
    field :duration, :integer, default: 0

    field :duration_time, Ecto.Time, virtual: true

    belongs_to :meeting_location, Grid.Location

    belongs_to :vendor, Grid.Vendor
    belongs_to :experience, Grid.Experience
    belongs_to :default_price, Grid.Price

    has_many :prices, Grid.Price
    has_many :start_times, Grid.StartTime
    has_many :product_amenity_options, Grid.ProductAmenityOption

    has_many :amenity_options, through: [:product_amenity_options, :amenity_option]
    has_many :categories, through: [:experience, :experience_categories, :category]
    has_one :activity, through: [:experience, :activity]

    timestamps
  end

  #############
  ## Queries ##
  #############

  def for_date(query \\ __MODULE__, date)
  def for_date(query, nil), do: query
  def for_date(query, %{year: year, month: month, day: day}) do
    dotw = Calendar.Date.day_of_week_name({year, month, day})
      |> String.downcase
      |> String.to_atom

    from p in query,
      where: p.published == true,
      join: time in assoc(p, :start_times),
        where: field(time, ^dotw) == true,
      join: s in assoc(time, :season),
        where: (
        # a normal range, kept within one year
        # greater than start and less than end
        # starts before or on date
        (s.start_date_month < ^month or (s.start_date_month == ^month and s.start_date_day <= ^day))
        and
        # ends after or on date
        (s.end_date_month > ^month or (s.end_date_month == ^month and s.end_date_day >= ^day))
      )
      or (
        # a year that spans a year, like a winter season (nov '15 - feb '16)
        (s.start_date_month > s.end_date_month or (s.start_date_month == s.end_date_month and s.start_date_day > s.end_date_day))
        and (
          # greater than start or less than end
          # starts on or before date
          (s.start_date_month < ^month or (s.start_date_month == ^month and s.start_date_day <= ^day))
          or
          # ends after date. so, date is in april, season runs from december to may...
          (s.end_date_month > ^month or (s.end_date_month == ^month and s.end_date_day >= ^day))
        )
      )
  end

  def set_duration_time(model = %__MODULE__{duration: duration}) do
    hours   = div(duration, 60)
    minutes = rem(duration, 60)
    time = %Ecto.Time{hour: hours, min: minutes}
    %{model | duration_time: time}
  end

  ##########################################
  ## Changesets, Constraints, Validations ##
  ##########################################

  defp pickup_and_location_constraints(changeset) do
    pickup   = fetch_field(changeset, :pickup)
    location = fetch_field(changeset, :meeting_location_id)
    case {pickup, location} do
      {{:model, true},   {:changes, nil}}    -> changeset
      {{:model,    _},   {:changes, change}} -> put_change(changeset, :pickup, !change)

      {{:changes,  true}, _}        -> put_change(changeset, :meeting_location_id, nil)
      {{:changes, false}, {_, nil}} -> add_error(changeset, :meeting_location_id, "Please supply a meeting location.")
      _  -> changeset
    end
  end

  @creation_fields ~w(vendor_id experience_id)a
  @required_fields ~w(description name published duration)a
  @optional_fields ~w(pickup experience_id meeting_location_id)a

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
    |> validate_length(:description, min: 1)
    |> validate_number(:duration, greater_than: 0)
    |> foreign_key_constraint(:experience_id)
    |> pickup_and_location_constraints()
    |> foreign_key_constraint(:meeting_location_id)
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
