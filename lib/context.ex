defmodule Saloon.Context do
  import :erlang, only: [get: 1, put: 2]
  def user, do: get(:user)
  def user(user), do: put(:user, user)
  def language, do: get(:language)
  def language(language), do: put(:language, language)
end
