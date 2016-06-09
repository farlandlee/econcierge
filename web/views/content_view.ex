defmodule Grid.ContentView do
  use Grid.Web, :view

  alias Grid.{
    ContentItem,
    Repo
  }

  def get(context, name, default \\ "") do
    item = case Repo.get_by(ContentItem, context: context, name: name) do
      nil ->
        ContentItem.creation_changeset(context, name, default)
        |> Repo.insert!
      item -> item
    end

    raw(item.content)
  end
end
