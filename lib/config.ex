defmodule Saloon.Config do
  use ExConfig.Object

  defproperty http_port, default: 55556
  defproperty template_root, default: 'priv/templates'
  defproperty silent, default: false
  defproperty controller_prefix, default: "Elixir-Saloon-"
  defproperty controller_postfix, default: "-Controller"
  defproperty controller_404, default: Saloon.C404

  def sys_config(config) do
    [
      saloon: [
        controller_prefix: config.controller_prefix,
        controller_postfix: config.controller_postfix,
        c404: config.controller_404,
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
