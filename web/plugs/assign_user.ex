defmodule Grid.Plugs.AssignUser do
  import Plug.Conn

  alias Grid.Repo
  alias Grid.User

  def init(opts), do: opts

  def call(conn, _) do
    id = get_session(conn, :user_id)

    current_user = cond do
      user = conn.assigns[:current_user] -> user # for tests
      user = id && Repo.get(User, id)    -> user
      true -> nil
    end

    assign(conn, :current_user, current_user)
  end
end
