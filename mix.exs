defmodule LingualeoSlackBot.Mixfile do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps,
      name: "LingualeoSlackBot",
      version: "1.0.0.beta0",
      docs: [
        main: "main",
        extras: ["docs/main.md"]
      ]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options.
  #
  # Dependencies listed here are available only for this project
  # and cannot be accessed from applications inside the apps folder
  defp deps do
    [
      {:ex_doc, github: "elixir-lang/ex_doc", ref: "2eee86869710997df432f83230d228134c332d7a", only: :dev},
      {:exjsx, "3.2.1"},
      {:credo, "~> 0.4", only: [:dev, :test]},
      {:mock, "~> 0.2.0", only: :test}
    ]
  end
end
