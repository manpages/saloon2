defmodule Saloon.Util do
  import :erlang, only: [element: 2]
  defmodule Cookie do
    def get(key, req) do
      element 1, :cowboy_req.cookie(key, req, {:undefined})
    end
  end
  defmodule Post do
    def get(key, req) do
      :proplists.get_value key, element(1, :cowboy_req.bosy_qs(req)), :undefined
    end
  end
  defmodule String do
    def from_hex(<<x :: 128>>) do
      format('~32.16.0b', x)
    end
    def from_hex(<<x :: 160>>) do
      format('~40.16.0b', x)
    end
    def from_hex(<<x :: 256>>) do
      format('~64.16.0b', x)
    end
    def from_hex(<<x :: 512>>) do
      format('~128.16.0b', x)
    end
    defp format(format, x), do: list_to_binary :lists.flatten(:io_lib.format(format, [x]))
  end
end
