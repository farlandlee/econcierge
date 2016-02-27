defmodule Grid.Mixfile do
  use Mix.Project

  def project do
    [app: :grid,
     version: "0.0.1",
     elixir: "1.2.2",
     elixirc_options: [{:warnings_as_errors, true}],
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     test_coverage: [tool: Coverex.Task, console_log: false],
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Grid, []},
     applications: [
       :ex_aws,
       :calendar,
       :httpoison,
       :phoenix,
       :phoenix_html,
       :cowboy,
       :logger,
       :oauth2,
       :phoenix_ecto,
       :postgrex,
       :rollbax,
       :stripity_stripe
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
      {:calendar, "~> 0.12.4"},
      {:coverex, "~> 1.4.8", only: :test},
      {:cowboy, "~> 1.0"},
      {:ex_aws, "~> 0.4.10"},
      {:ex_machina, "~> 0.5", only: :test},
      {:httpoison, "~> 0.7"},
      {:inflex, "~> 1.5.0"},
      {:oauth2, "~> 0.5.0"},
      {:phoenix, "~> 1.1.4"},
      {:phoenix_ecto, "~> 2.0"},
      {:poison, "~> 1.5.2"},
      {:postgrex, "~> 0.11.0"},
      {:phoenix_html, "~> 2.5"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:rollbax, "~> 0.5"},
      {:slugger, git: "git://github.com/h4cc/slugger.git"},
      {:stripity_stripe, "~> 1.3.0"},
      {:uuid, "~> 1.1"}
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
      "deps.client": &client_deps/1,
      "test.all": [&mix_test/1, "test.client"],
      "test.client": [&test_client/1],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      "ecto.seed": ["run priv/repo/seeds.exs"],
      "s": [&ember_build/1, "phoenix.server"]
    ]
  end

  defp client_deps(_) do
    Mix.Shell.IO.info [:yellow, "npm install"]
    Mix.Shell.IO.cmd "npm install"
    Mix.Shell.IO.info [:yellow, "bower install"]
    Mix.Shell.IO.cmd "bower install"

    Mix.Shell.IO.info [:yellow, "npm install (client)"]
    Mix.Shell.IO.cmd "cd client && npm install"
    Mix.Shell.IO.info [:yellow, "bower install (client)"]
    Mix.Shell.IO.cmd "cd client && bower install"

    Mix.Shell.IO.info [:green, "Done."]
  end

  defp ember_build(_) do
    spawn_link fn ->
      # I can't believe how easy and awesome this is. <3 erlang processes
      cmd("cd client && ./node_modules/ember-cli/bin/ember build --watch")
    end
  end

  defp mix_test(_) do
    #use cmd to avoid MIX_ENV errors from running the task directly
    cmd("mix test")
  end

  defp test_client(_) do
    Mix.Shell.IO.info [:yellow, "ember test"]
    cmd("cd client && ./node_modules/ember-cli/bin/ember test --silent")
  end

  defp cmd(cmd) do
    case Mix.Shell.IO.cmd(cmd) do
      0 -> :ok
      _ -> raise Mix.Error, message: "`#{cmd}` exited with nonzero status"
    end
  end
end
