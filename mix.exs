defmodule Abracadabra.Mixfile do
  use Mix.Project

  def project do
    [app: :abracadabra,
     version: "0.1.0",
     elixir: "~> 1.4",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger],
     mod: {Abracadabra.Application, []},
     applications: [:postgrex, :ecto, :httpotion]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:ecto, "~> 2.2.0"},
     {:postgrex, ">= 0.0.0"},
     {:httpotion, "~> 3.0.2"},
     {:floki, "~> 0.18.0"},
     {:flow, "~> 0.11"},
     {:timex, "~> 3.1"},
     {:progress_bar, "> 0.0.0"},
     
     {:exvcr, "~> 0.8", only: :test}]
  end
end
