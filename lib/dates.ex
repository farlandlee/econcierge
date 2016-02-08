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
end
