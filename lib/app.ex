defmodule Saloon.App do
  use Application.Behaviour
  
  def start(_,_) do
    env = Application.environment :saloon

    # hack to ensure that binary_to_existing_atom won't fail
    lc x inlist :filelib.wildcard('ebin/*.beam'), do: :code.ensure_loaded(list_to_atom( Path.basename(Path.basename(x, '.beam')) ))

    # emysql. I'll make storage backend configurable... some day.
    :emysql.add_pool(:saloon, env[:emysql_pool_size], 
                      env[:emysql_user], env[:emysql_password], 
                      env[:emysql_host], env[:emysql_port], 
                      env[:emysql_database], :utf8)

    # cowboy
    dispatch = :cowboy_router.compile env[:http_dispatch]
    :cowboy.start_http :http, 100, [port: env[:http_port]], [env: [dispatch: dispatch]]
  end

end
