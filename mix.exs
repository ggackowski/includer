defmodule Includer.MixProject do
  use Mix.Project

  def project do
    [
      app: :includer,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      description: "Program that can include missing header files to the C source code.",
      name: "Includer",
      source_url: "http://github.com/ggackowski/includer",
      deps: deps(),
      package: package(),
      escript: [
        main_module: Includer.CLI,
        comment: "Includer",
      ]

    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.6"},
      {:floki, "~> 0.26.0"}
    ]
  end

  defp package, do:
    [
    name: "includer",
    licenses: ["OPL-1.0"],
    links: %{"GitHub" => "https://github.com/ggackowski/includer"}
    ]
end
