defmodule Grid.Plugs.RequireParams do
  def init(required_params) do
    List.wrap(required_params)
  end

  def call(conn, required_params) do
    for param <- required_params do
      unless conn.params[param] do
        raise Phoenix.MissingParamError, key: param
      end
    end
    conn
  end
end
