defmodule Grid.Admin.Vendor.Product.StartTimeView do
  use Grid.Web, :view

  defdelegate season_text(s),
    to: Grid.Admin.Vendor.VendorActivity.SeasonView,
    as: :text

  @weekdays ~w(monday tuesday wednesday thursday friday)a
  @weekend  ~w(saturday sunday)a
  @days @weekdays ++ @weekend

  def dotw_shortcodes(start_time) do
    @days
    |> Enum.filter(&Map.get(start_time, &1))
    |> Enum.map(&Grid.Dates.day_abbr/1)
    |> Enum.join(" | ")
  end

  def checkboxes(form, :weekdays) do
    checkboxes_for(form, @weekdays)
  end

  def checkboxes(form, :weekend) do
    checkboxes_for(form, @weekend)
  end

  defp checkboxes_for(f, days) do
    for dotw <- days, name = Phoenix.Naming.humanize(dotw) do
      [
        checkbox(f, dotw, class: "form-control-inline"),
        " ",
        label(f, dotw, name, class: "control-label"),
        ~e(<br>)
      ]
    end
  end
end
