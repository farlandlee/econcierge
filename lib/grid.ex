defmodule Grid do
  use Application

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Grid.Endpoint, []),
      worker(Grid.Repo, []),
      worker(TripAdvisor, []),
      worker(Grid.Stripe, [])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    opts = [strategy: :one_for_one, name: Grid.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Grid.Endpoint.config_change(changed, removed)
    :ok
  end

  @doc """
  Loads variable from either config or system variable.

  If the value is configured to a `{:system, some_env_var :: string}` tuple in config.exs,
  the returned value will be the value of `System.get_env(some_env_var)`.
  """
  def get_env(key, default \\ nil) do
    case Application.get_env(:grid, key, default) do
      {:system, sys_env} -> System.get_env(sys_env) || default
      result -> result
    end
  end

  @doc "wraps `get_env/2` in {:ok, result} tuple or else :error if not found"
  def fetch_env(key) do
    case get_env(key, :error) do
      :error -> :error
      value -> {:ok, value}
    end
  end

  @doc "see fetch_env/1"
  def fetch_env!(key) do
    case get_env(key, :error) do
      :error ->
        raise ArgumentError, message: "No value found for application variable #{key}"
      value ->
        value
    end
  end
end
