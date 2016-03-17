defmodule Grid.NotFoundError do
  defexception message: "Not found"
end

defmodule Grid.CartError do
  defexception message: "", product: nil
end

defimpl Plug.Exception, for: Grid.NotFoundError do
  def status(_exception), do: 404
end

defimpl Plug.Exception, for: Grid.CartError do
  def status(_exception), do: 422
end
