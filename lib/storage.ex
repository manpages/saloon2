defmodule Saloon.Storage do
  defmodule SQL do
    def query(query, _options // []) do
      :emysql.execute pool, query
    end
    defp pool, do: Application.environment(:saloon)[:emysql_pool]
  end
end
