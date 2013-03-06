defmodule Saloon.Index do
  def init({:tcp, :http}, req, []) do
    {:ok, req, :undefined}
  end

  def handle(req, state) do
    {:ok, req} = :cowboy_req.reply 200, [], "<h1>It Works!</h1>", req
    {:ok, req, state}
  end

  def terminate(_,_,_) do
    :ok
  end
end
