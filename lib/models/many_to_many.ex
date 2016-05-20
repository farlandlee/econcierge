defmodule Grid.Models.ManyToMany do
  alias Grid.Repo

  import Ecto, only: [assoc: 2, build_assoc: 3]

  def manage_associated(model, relation, key, nil), do:
    manage_associated(model, relation, key, [])

  def manage_associated(model, relation, key, ids) do
    Repo.delete_all(assoc(model, relation))

    # Whaa?
    ids = Enum.filter(ids, fn
      "false" -> false
      _ -> true
    end)

    for s_id <- ids, {id, ""} = Integer.parse(s_id) do
      build_assoc(model, relation, Map.put(%{}, key, id))
      |> Repo.insert!
    end
  end
end
