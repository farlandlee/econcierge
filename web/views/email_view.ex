defmodule Grid.EmailView do
  use Grid.Web, :view

  def date_string(stamp) do
    Ecto.DateTime.to_erl(stamp)
    |> Calendar.DateTime.from_erl!("MST")
    |> Calendar.Strftime.strftime!("%a, %B %e, %Y")
  end

  def time_string(stamp) do
    Ecto.DateTime.to_erl(stamp)
    |> Calendar.DateTime.from_erl!("MST")
    |> Calendar.Strftime.strftime!("%I:%M%P")
  end

  def people_count(%{"items" => items}) do
    count = Enum.reduce(items, 0, fn(i, acc) ->
      acc + i["quantity"] * i["price_people_count"]
    end)

    case count do
      1 -> "1 person"
      n -> "#{n} people"
    end
  end

  def location(%{meeting_location: location}) do
    case location do
      nil -> "Pickup"
      _ -> "#{location.address1}, #{location.city}, #{location.state} #{location.zip}"
    end
  end
end
