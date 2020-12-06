defmodule Qew.MixProject do
  use Mix.Project

  def project do
    [
      app: :qew,
      version: "0.1.0",
      elixir: "~> 1.11",
      start_permanent: Mix.env() == :prod
    ]
  end
end
