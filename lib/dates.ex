defmodule Grid.Dates do
  @months [
    {"January", "1"},
    {"February", "2"},
    {"March", "3"},
    {"April", "4"},
    {"May", "5"},
    {"June", "6"},
    {"July", "7"},
    {"August", "8"},
    {"September", "9"},
    {"October", "10"},
    {"November", "11"},
    {"December", "12"},
  ]
  def months, do: @months

  @days [
    {"Monday", "M"},
    {"Tuesday", "Tu"},
    {"Wednesday", "W"},
    {"Thursday", "Th"},
    {"Friday", "F"},
    {"Saturday", "Sa"},
    {"Sunday", "Su"}
  ]

  for {day, short} <- @days,
  a = day |> String.downcase |> String.to_atom do

    def day_abbr(unquote(a)), do: unquote(short)

  end

  @doc """
  Parses an iso8601 date string to Calendar.Date struct.

    iex> parse_date("1988-08-25")
    {:ok, %Calendar.Date{year: 1988, month: 8, day: 25}}

    iex> parse_date("1988-8-25")
    {:bad_format, nil}

    iex> parse_date(nil)
    {:bad_format, nil}
  """
  def parse_date(nil), do: parse_date("")
  def parse_date(date) do
    Calendar.Date.Parse.iso8601(date)
  end
end
