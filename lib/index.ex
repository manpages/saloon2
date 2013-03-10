defmodule Saloon.Index do
  def init({:tcp, :http}, req, []) do
    {:ok, req, :undefined}
  end

  def handle(req, _state) do
    apply controller(req), :handle, [req, [__MODULE__]]
  end

  def terminate(_,_,_) do
    :ok
  end

  defp controller(req) do
    env = Application.environment :saloon
    {path, _} = :cowboy_req.path(req)
    [controller|_args] = String.split String.strip(path, ?/), "/"
    IO.puts "Trying to convert #{env[:controller_prefix]}#{controller}#{env[:controller_postfix]} to existing atom..."
    try do 
      binary_to_existing_atom(<<
        env[:controller_prefix] :: binary, 
        controller :: binary,
        env[:controller_postfix] :: binary>>)
    catch _,_ ->
      IO.puts "...failed"
      env[:c404]
    end
  end
end
