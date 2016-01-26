defmodule Grid.Repo do
  use Ecto.Repo, otp_app: :grid

  import Ecto.Query

  def alphabetical(query, field \\ :name) do
    query |> order_by(^field)
  end
end
