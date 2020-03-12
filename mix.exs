defmodule Escipion.MixProject do
  use Mix.Project

  def project do
    [
      app: :escipion_bot,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Escipion.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:poison, "~> 3.1"},
      {:plug, "~> 1.9"},
      {:cowboy, "~> 2.7"},
      {:plug_cowboy, "~> 2.0"},
      {:httpoison, "~> 1.6"},
      {:logger_file_backend, "~> 0.0.11"},
      {:credo, "~> 1.2", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.12"},
      {:quantum, "~> 3.0-rc"}
    ]
  end
end
