defmodule Grid.Repo do
  use Ecto.Repo, otp_app: :grid

  import Ecto.Query

  def alphabetical(query, field \\ :name) do
    query |> order_by(^field)
  end

  def all_in_ids(query, ids)
  def all_in_ids(query, nil), do: all(query)
  def all_in_ids(query, ids) do
    all(from x in query, where: x.id in ^ids)
  end
end
