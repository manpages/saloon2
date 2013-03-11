defmodule Saloon.Mixfile do
  use Mix.Project

  def project do
    [ app: :saloon,
      version: "0.0.1",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [applications: [:crypto, :ranch, :cowboy, :exconfig, :emysql],
     mod: {Saloon.App, []}]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [
      {:cowboy, github: "extend/cowboy"},
        {:ranch, github: "extend/ranch"},
      {:exconfig, github: "yrashk/exconfig"},
      {:emysql, github: "Eonblast/Emysql"},
    ]
  end
end
