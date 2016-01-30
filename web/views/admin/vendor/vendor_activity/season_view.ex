defmodule Grid.Admin.Vendor.VendorActivity.SeasonView do
  use Grid.Web, :view

  alias Grid.Season

  defp justify_integer(int) do
    int
    |> Integer.to_string
    |> String.rjust(2, ?0)
  end

  defp rendered_date(month, day) do
    month = justify_integer(month)
    day = justify_integer(day)
    "#{month}/#{day}"
  end

  @doc """
    iex> start_date(%Grid.Season{
    ...>   name: "Peak Season",
    ...>   start_date_month: 6, start_date_day: 1,
    ...>   end_date_month: 8, end_date_day: 30
    ...> })
    "06/01"
  """
  def start_date(%Season{start_date_day: day, start_date_month: month}) do
    rendered_date(month, day)
  end

  @doc """
    iex> end_date(%Grid.Season{
    ...>   name: "Peak Season",
    ...>   start_date_month: 6, start_date_day: 1,
    ...>   end_date_month: 8, end_date_day: 30
    ...> })
    "08/30"
  """
  def end_date(%Season{end_date_day: day, end_date_month: month}) do
    rendered_date(month, day)
  end

  @doc """
    iex> date_range(%Grid.Season{
    ...>   name: "Peak Season",
    ...>   start_date_month: 6, start_date_day: 1,
    ...>   end_date_month: 8, end_date_day: 30
    ...> })
    "(06/01 - 08/30)"
  """
  def date_range(season) do
    "(#{start_date(season)} - #{end_date(season)})"
  end

  @doc """
    iex> text(%Grid.Season{
    ...>   name: "Peak Season",
    ...>   start_date_month: 6, start_date_day: 1,
    ...>   end_date_month: 8, end_date_day: 30
    ...> })
    "Peak Season (06/01 - 08/30)"
  """
  def text(season) do
    "#{season.name} #{date_range(season)}"
  end

  def yearless_date_select(form, field, opts \\ []) do
    year_name = "#{field_name(form, field)}[year]"
    builder = fn b ->
      ~e"""
      <%= hidden_input form, field, value: 0, name: year_name %>
      <%= b.(:month, []) %> / <%= b.(:day, []) %>
      """
    end

    date_select(form, field, [builder: builder] ++ opts)
  end

  def sort_by_date(seasons) do
    Enum.sort(seasons, fn s1, s2 ->
      {s1.start_date_month, s1.start_date_day}
      <
      {s2.start_date_month, s2.start_date_day}
    end)
  end

  def month_select(form, field, opts \\ []) do
    select(form, field, Grid.Dates.months, opts)
  end

  def day_select(form, field, opts \\ []) do
    select(form, field, 1..31 |> Enum.map(&justify_integer/1), opts)
  end

  def season_date_select(form, field) do
    month_field = "#{Atom.to_string(field)}_month"
      |> String.to_existing_atom
    day_field = "#{Atom.to_string(field)}_day"
      |> String.to_existing_atom
    [month_select(form, month_field), " / ", day_select(form, day_field)]
  end

end
