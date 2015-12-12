ExUnit.start

Mix.Task.run "ecto.create", ["--quiet"]
Mix.Task.run "ecto.migrate", ["--quiet"]
Ecto.Adapters.SQL.begin_test_transaction(Grid.Repo)

defmodule Grid.TestHelper do
  def long_string(length) do
    1..length
    |> Enum.reduce("", fn(_, acc) -> acc <> "n" end)
  end
end
