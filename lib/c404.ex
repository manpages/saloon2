defmodule Saloon.C404 do
  def init({:tcp, :http}, req, _) do
    {:ok, req, :undefined}
  end

  def handle(req, state) do
    {:ok, req} = :cowboy_req.reply 404, [], "<!doctype html>
    <html>
      <head>
        <title>404</title>
      </head>
      <body>
        <h1>404</h1>
        <p>
          Sorry, stormtrooper, but your droids are in another castle.
        </p>
      </body>
    </html>
    ", req
    {:ok, req, state}
  end

  def terminate(_,_,_), do: :ok
end
