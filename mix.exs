defmodule Leaky.MixProject do
  use Mix.Project

  def project do
    [
      app: :leaky,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {Leaky.Application, []}
    ]
  end

  defp deps do
    [
      {:erlexec, "~> 1.18"}
    ]
  end
end
