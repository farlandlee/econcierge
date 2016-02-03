defmodule Grid.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  imports other functionality to make it easier
  to build and query models.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      use Phoenix.ConnTest

      alias Grid.Factory
      alias Grid.Repo
      import Ecto.Model
      import Ecto.Query, only: [from: 2]

      import Grid.Router.Helpers

      import Grid.ConnCase

      # The default endpoint for testing
      @endpoint Grid.Endpoint
    end
  end

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(Grid.Repo, [])
    end

    conn = if tags[:no_auth] do
      Phoenix.ConnTest.conn()
    else
      user = Grid.Repo.insert! %Grid.User{
        name: "Test User",
        email: "test@outpostjh.com"
      }
      Phoenix.ConnTest.conn()
      |> Plug.Conn.assign(:current_user, user)
    end

    {:ok, conn: conn}
  end

  def recycle_with_auth(conn) do
    conn
    |> Phoenix.ConnTest.recycle()
    |> Plug.Conn.assign(:current_user, conn.assigns.current_user)
  end
end
