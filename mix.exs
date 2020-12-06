defmodule Qew.MixProject do
  use Mix.Project

  def project do
    [
      app: :qew,
      version: "0.1.0",
      elixir: "~> 1.10",
      start_permanent: Mix.env() == :prod,
      description: "Elixir wrapper around erlang :queue module. Module keeps track of the queue length.",
      package: package(),
      deps: deps()
    ]
  end

  defp deps do
    [
      {:ex_doc, "~> 0.20", only: :dev}
    ]
  end

  defp package do
    [
      name: :qew,
      files: ["lib", "mix.exs", "README*"],
      licenses: ["MIT"],
      links: %{
        "GitHub" => "https://github.com/galina/qew"
      }
    ]
  end
end
