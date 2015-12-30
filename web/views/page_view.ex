defmodule Grid.PageView do
  use Grid.Web, :view

  def activity_examples(activities) do
    examples = Enum.slice(activities, 0..2)
    |> Enum.map(&(&1.name))
    |> Enum.join(", ")

    examples <> ", etc."
  end
end
