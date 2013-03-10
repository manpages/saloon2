defmodule Saloon.App do
  use Application.Behaviour
  
  def start(_,_) do
    lc x inlist :filelib.wildcard('ebin/*.beam'), do: :code.ensure_loaded(list_to_atom( Path.basename(Path.basename(x, '.beam')) ))
    env = Application.environment :saloon
    dispatch = :cowboy_router.compile env[:http_dispatch]
    :cowboy.start_http :http, 100, [port: env[:http_port]], [env: [dispatch: dispatch]]
  end
end
