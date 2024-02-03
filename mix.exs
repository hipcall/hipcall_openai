defmodule HipcallOpenai.MixProject do
  use Mix.Project

  @source_url "https://github.com/hipcall/hipcall_openai"
  @version "0.3.0"

  def project do
    [
      app: :hipcall_openai,
      name: "HipcallOpenai",
      description: "Unofficial OpenAI API Wrapper written in Elixir.",
      version: @version,
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      package: package(),
      docs: docs()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {HipcallOpenai.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finch, "~> 0.17.0"},
      {:jason, "~> 1.4"},
      {:nimble_options, "~> 1.1"},
      {:ex_doc, "~> 0.31", only: :dev, runtime: false}
    ]
  end

  def package do
    [
      maintainers: ["Onur Ozgur OZKAN"],
      licenses: ["MIT"],
      links: %{
        "Website" => "https://www.hipcall.com/en-gb/",
        "GitHub" => @source_url
      }
    ]
  end

  def docs do
    [
      main: "readme",
      name: "HipcallOpenai",
      canonical: "https://hex.pm/packages/hipcall_openai",
      source_ref: "v#{@version}",
      source_url: @source_url,
      extras: ["README.md", "CHANGELOG.md", "LICENSE.md"]
    ]
  end
end
