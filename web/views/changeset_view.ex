defmodule Grid.ChangesetView do
  use Phoenix.HTML

  def translate_error({msg, opts}) do
    String.replace(msg, "%{count}", to_string(opts[:count]))
  end
  def translate_error(msg), do: msg

  @doc """
  Traverses and translates changeset errors.

  See `Ecto.Changeset.traverse_errors/2` and
  `Grid.ErrorHelpers.translate_error/1` for more details.
  """
  def translate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
  end

  @doc """
  Generates tag for inlined form input errors.
  """
  def error_tag(form, field) do
    if error = form.errors[field] do
      content_tag :span, translate_error(error), class: "help-block"
    end
  end
end
