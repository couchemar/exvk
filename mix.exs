defmodule Exvk.Mixfile do
  use Mix.Project

  def project do
    [ app: :exvk,
      version: "0.0.1",
      elixir: "~> 0.10.3-dev",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
     mod: { Exvk, [] },
     applications: [:httpotion, :exreloader]
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "~> 0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [
     { :httpotion,  github: "couchemar/httpotion" },
     { :exreloader, github: "couchemar/exreloader" },
     { :jsex,       github: "talentdeficit/jsex" },
     { :exactor,    github: "sasa1977/exactor" },
     # Используем пока форк.
     { :exlager,    github: "michalwski/exlager" }
    ]
  end
end
