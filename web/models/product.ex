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
    has_many :order_items, Grid.OrderItem

    has_many :amenity_options, through: [:product_amenity_options, :amenity_option]
    has_many :categories, through: [:experience, :experience_categories, :category]
    has_many :seasons, through: [:start_times, :season]
    has_one :activity, through: [:experience, :activity]

    timestamps
  end

  ####################
  ## Virtual Fields ##
  ####################

  def set_duration_time(model = %__MODULE__{duration: duration}) do
    hours   = div(duration, 60)
    minutes = rem(duration, 60)
    time = %Ecto.Time{hour: hours, min: minutes}
    %{model | duration_time: time}
  end

  #############
  ## Queries ##
  #############

  def published(query \\ __MODULE__) do
    from p in query, where: p.published == true
  end

  def for_experience(query \\ __MODULE__, id)
  def for_experience(query, nil), do: query
  def for_experience(query, id) do
    from p in query, where: p.experience_id == ^id
  end

  def for_date(query \\ __MODULE__, date)
  def for_date(query, nil), do: query
  def for_date(query, %Ecto.Date{} = date) do
    date = Ecto.Date.to_erl(date)
      |> Calendar.Date.from_erl!

    dotw = Calendar.Date.day_of_week_name(date)
      |> String.downcase
      |> String.to_atom

    from p in query,
      join: time in assoc(p, :start_times),
        where: field(time, ^dotw) == true,
      join: s in assoc(time, :season),
        where: ^date >= s.start_date and ^date <= s.end_date
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

  @doc """
  A product is bookable if it is published and has the necessary requirement
  for booking, i.e. default price w/ amount and a start_time.
  """
  def check_bookability(%__MODULE__{published: false} = product), do: {:ok, product}
  def check_bookability(%__MODULE__{start_times: start_times, default_price: price, published: true} = product) do
    errors = []

    if Enum.empty?(start_times) do
      errors = ['Product must have at least one start time' | errors]
    end

    if price == nil do
      errors = ['Must have default price' | errors]
    end

    if price && length(price.amounts) == 0 do
      errors = ['Default price must have amounts' | errors]
    end

    case errors do
      [] -> {:ok, product}
      errors -> {:error, errors}
    end
  end
end
