defmodule Grid.Models.Validations do
  import Ecto.Changeset

  @email_regex ~r/(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)/
  def validate_email(changeset, key \\ :email) do
    validate_format(changeset, key, @email_regex)
  end
end
