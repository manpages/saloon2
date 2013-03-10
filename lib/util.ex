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
end
