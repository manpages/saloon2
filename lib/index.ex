defmodule Saloon.Index do
  def init({:tcp, :http}, req, []) do
    {:ok, req, :undefined}
  end

  def handle(req, state) do
    IO.puts "#{inspect controller(req)}"
    {:ok, req} = :cowboy_req.reply 200, [], "<h1>It works!</h1>", req
    {:ok, req, state}
  end

  def terminate(_,_,_) do
    :ok
  end

  defp controller(req) do
    env = Application.environment :saloon
    {path, _} = :cowboy_req.path(req)
    [controller|_args] = String.split String.strip(path, ?/), "/"
    try do 
      binary_to_existing_atom(<<
        env[:controller_prefix] :: binary, 
        controller :: binary,
        env[:controller_postfix] :: binary>>)
    catch 
      x,y -> IO.puts "#{inspect {x,y}}"; env[:c404]
    end
  end
end
