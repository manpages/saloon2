defmodule Saloon.Config do
  use ExConfig.Object

  defproperty http_port, default: 55556
  defproperty template_root, default: 'priv/templates'
  defproperty silent, default: false
  defproperty controller_prefix, default: "Elixir-Saloon-"
  defproperty controller_postfix, default: "-Controller"
  defproperty controller_404, default: Saloon.C404
  defproperty emysql_user, default: 'root'
  defproperty emysql_password, default: ''
  defproperty emysql_pool_size, default: 2
  defproperty emysql_host, default: 'localhost'
  defproperty emysql_port, default: 3306
  defproperty emysql_database, default: 'hello_database'

  def sys_config(config) do
    [
      saloon: [
        controller_prefix: config.controller_prefix,
        controller_postfix: config.controller_postfix,
        c404: config.controller_404,
        emysql_user: config.emysql_user,
        emysql_password: config.emysql_password,
        emysql_pool_size: config.emysql_pool_size,
        emysql_host: config.emysql_host,
        emysql_port: config.emysql_port,
        emysql_database: config.emysql_database,
        http_port: config.http_port,
        http_dispatch: [{:_, [
          {"/static/[...]", :cowboy_static, [
            directory: ["priv","static"],
            mimetypes: [
              {".txt", ["text/plain"]},
              {".css", ["text/css"]},
              {".js",  ["application/javascript"]},
              {".png", ["image/png"]},
              {".jpg", ["image/jpeg"]},
              {".log", ["text/plain"]},
            ]
          ]},
          {:_, Saloon.Index, []},
        ]}],
      ],
    ]
  end

  def sys_config!(filename, config) do
    File.write!(filename, :io_lib.format("~p.~n",[sys_config(config)]))
  end
end
