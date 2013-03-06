defmodule Saloon.Config do
  use ExConfig.Object

  defproperty http_port, default: 55556
  defproperty template_root, default: 'priv/templates'
  defproperty silent, default: false

  def sys_config(config) do
    [
      saloon: [
        http_port: config.http_port,
        http_dispatch: [{:_, [
          {:_, Saloon.Index, []},
        ]}],
      ],
    ]
  end

  def sys_config!(filename, config) do
    File.write!(filename, :io_lib.format("~p.~n",[sys_config(config)]))
  end
end
