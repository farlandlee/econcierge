defmodule Grid.Admin.Vendor.VendorActivity.SeasonView do
  use Grid.Web, :view

  alias Grid.Season

  @doc """
    iex> rendered_date(%Ecto.Date{year: 2016, month: 6, day: 1})
    "06/01/2016"
  """
  def rendered_date(%Ecto.Date{} = date) do
    {:ok, rendered} = Ecto.Date.to_erl(date)
      |> Calendar.Date.from_erl!
      |> Calendar.Strftime.strftime("%m/%d/%Y")

    rendered
  end

  @doc """
    iex> start_date(%Grid.Season{
    ...>   start_date: %Ecto.Date{year: 2016, month: 6, day: 1}
    ...> })
    "06/01/2016"
  """
  def start_date(%Season{start_date: start_date}) do
    rendered_date(start_date)
  end

  @doc """
    iex> end_date(%Grid.Season{
    ...>   end_date: %Ecto.Date{year: 2016, month: 8, day: 30}
    ...> })
    "08/30/2016"
  """
  def end_date(%Season{end_date: end_date}) do
    rendered_date(end_date)
  end

  @doc """
    iex> date_range(%Grid.Season{
    ...>   name: "Peak Season",
    ...>   start_date: %Ecto.Date{year: 2016, month: 6, day: 1},
    ...>   end_date: %Ecto.Date{year: 2016, month: 8, day: 30}
    ...> })
    "(06/01/2016 - 08/30/2016)"
  """
  def date_range(season) do
    "(#{rendered_date(season.start_date)} - #{rendered_date(season.end_date)})"
  end

  @doc """
    iex> text(%Grid.Season{
    ...>   name: "Peak Season",
    ...>   start_date: %Ecto.Date{year: 2016, month: 6, day: 1},
    ...>   end_date: %Ecto.Date{year: 2016, month: 8, day: 30}
    ...> })
    "Peak Season (06/01/2016 - 08/30/2016)"
  """
  def text(season) do
    "#{season.name} #{date_range(season)}"
  end

  def sort_by_date(seasons) do
    Enum.sort(seasons, fn s1, s2 ->
      s1.start_date < s2.start_date
    end)
  end

end
