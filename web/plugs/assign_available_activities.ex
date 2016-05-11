defmodule Grid.Plugs.AssignAvailableActivities do
  import Plug.Conn
  import Ecto.Query, only: [from: 2]

  alias Grid.Repo
  alias Grid.Activity

  def init(default), do: default

  def call(conn, _) do
    activities = Repo.all(
      from a in Activity,
      join: p in assoc(a, :products),
      where: p.published == true,
      distinct: true,
      order_by: a.name
    ) |> Enum.sort(&(&1.name < &2.name)) # Because postgres sorts differently on linux than max.

    assign(conn, :available_activities, activities)
  end
end
