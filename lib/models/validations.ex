defmodule Grid.Models.Validations do
  import Ecto.Changeset

  @email_regex ~r/(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)/
  def validate_email(changeset, key \\ :email) do
    validate_format(changeset, key, @email_regex)
  end

  @url_regex ~r/^(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$/
  def validate_url(changeset, key \\ :url) do
    validate_format(changeset, key, @url_regex)
  end

  def validate_date(changeset, field) do
    case get_field(changeset, field) do
      nil ->
        changeset
      date ->
        do_validate_date(changeset, field, date)
    end
  end

  defp do_validate_date(changeset, field, date) do
    case Ecto.Date.to_erl(date) |> Calendar.Date.from_erl do
      {:error, _} ->
        add_error(changeset, field, "Invalid date")
      _ ->
        changeset
    end
  end
end
