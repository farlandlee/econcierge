ExUnit.start

Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
Application.ensure_all_started :ex_machina
Ecto.Adapters.SQL.begin_test_transaction(Grid.Repo)

defmodule Grid.TestHelper do
  def long_string(length) do
    1..length
    |> Enum.reduce("", fn(_, acc) -> acc <> "n" end)
  end
end
