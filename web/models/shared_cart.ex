defmodule Grid.SharedCart do
  use Grid.Web, :model

  schema "shared_carts" do
    field :bookings, :map
    field :uuid, :string

    timestamps
  end

  @required_fields ~w(bookings)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def creation_changeset(params) do
    # `map` types can't be json lists, so wrap the list in an object
    params = Map.update!(params, "bookings", &(%{bookings: &1}))

    %__MODULE__{}
    |> cast(params, @required_fields, @optional_fields)
    |> put_change(:uuid, UUID.uuid4(:hex))
    |> validate_bookings
  end

  defp validate_bookings(changeset) do
    case get_field(changeset, :bookings) do
      %{bookings: [_|_] = bookings} ->
        Enum.reduce(bookings, changeset, &validate_booking/2)
      what ->
        IO.inspect what
        add_error(changeset, :bookings, "Invalid bookings")
    end
  end

  # A booking looks like this:
  #   %{
  #     "activity" => "1",
  #     "date" => "2016-04-25",
  #     "product" => "7",
  #     "quantities" => [%{"cost" => 100, "id" => 13, "quantity" => 1}],
  #     "startTime" => %{"id" => 7, "time" => "00:00:00"}
  #   }
  defp validate_booking(booking, changeset) do
    changeset
    |> validate_booking_has_all_keys(booking)
    |> validate_booking_quantities(booking)
    |> validate_booking_start_times(booking)
  end

  @required_booking_keys ~w(activity date product quantities startTime)
  defp validate_booking_has_all_keys(changeset, booking) do
    Enum.reduce(@required_booking_keys, changeset, fn req_key, changeset ->
      if Map.has_key? booking, req_key do
        changeset
      else
        add_error(changeset, :bookings, "Booking missing key: #{req_key}")
      end
    end)
  end

  defp validate_booking_quantities(changeset, %{"quantities" => qs}) do
    if Enum.all?(qs, &quantity_is_valid/1) do
      changeset
    else
      add_error(changeset, :quantities, "Invalid quantity.")
    end
  end

  @required_quantities_keys ~w(cost id quantity)
  defp quantity_is_valid(quantity) do
    Enum.each(@required_quantities_keys, &Map.has_key?(quantity, &1))
  end

  defp validate_booking_start_times(changeset, %{"startTime" => %{"id" => _, "time" => _}}) do
    changeset
  end

  defp validate_booking_start_times(changeset, _) do
    add_error(changeset, :start_time, "Invalid start time")
  end
end
