defmodule Grid.Mixfile do
  use Mix.Project

  def project do
    [app: :grid,
     version: "0.0.1",
     elixir: "~> 1.1",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Grid, []},
     applications: [
       :ex_aws,
       :httpoison,
       :phoenix,
       :phoenix_html,
       :cowboy,
       :logger,
       :phoenix_ecto,
       :postgrex
    ]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:arc, "~> 0.2.2"},
      {:cowboy, "~> 1.0"},
      {:ex_aws, "~> 0.4.10"},
      {:ex_machina, "~> 0.5", only: :test},
      {:httpoison, "~> 0.7"},
      {:inflex, "~> 1.5.0"},
      {:phoenix, "~> 1.1"},
      {:phoenix_ecto, "~> 2.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.3"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:slugger, git: "git://github.com/h4cc/slugger.git"}
    ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "s": ["phoenix.server"]
    ]
  end
end
