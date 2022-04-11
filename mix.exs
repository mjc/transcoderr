defmodule Transcoderr.MixProject do
  use Mix.Project

  def project do
    [
      app: :transcoderr,
      version: "0.1.0",
      elixir: "~> 1.13.0",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Transcoderr.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:broadway, "~> 1.0.0"},
      {:ecto_sql, "~> 3.7.0"},
      {:floki, ">= 0.0.0", only: :test},
      {:gettext, "~> 0.19.0"},
      {:jason, "~> 1.0"},
      {:phoenix_ecto, "~> 4.4.0"},
      {:phoenix_html, "~> 3.2.0"},
      {:phoenix_live_dashboard, "~> 0.6.0"},
      {:phoenix_live_reload, "~> 1.3.0", only: :dev},
      {:phoenix_live_view, "~> 0.17.0"},
      {:phoenix, "~> 1.6.6"},
      {:plug_cowboy, "~> 2.5.0"},
      {:postgrex, ">= 0.0.0"},
      {:telemetry_metrics, "~> 0.6.0"},
      {:telemetry_poller, "~> 1.0.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to install project dependencies and perform other setup tasks, run:
  #
  #     $ mix setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      setup: ["deps.get", "ecto.setup", "cmd npm install --prefix assets"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"]
    ]
  end
end
