defmodule Grid.PageView do
  use Grid.Web, :view

  def activity_examples(activities) do
    examples = Enum.slice(activities, 0..2)
    |> Enum.map(&(&1.name))
    |> Enum.join(", ")

    examples <> ", etc."
  end

  def kiosk_url(kiosk, action_link) do
    String.replace(action_link, "{{kiosk}}", kiosk.sub_domain)
  end
end
