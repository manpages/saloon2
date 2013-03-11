defmodule Saloon.Storage do
  defmodule SQL do
    def query(query, _options // []) do
      :emysql.execute pool, query
    end
    #TODO
    #def begin
    #def commit
    #def rollback
    #/TODO
    def select(from, options // []) do
      options = [{:from, from} | options]
      List.foldl [:what, :from, :join, :left_join, :right_join, :where, :group, :order, :limit], "SELECT ", 
        fn x, acc ->
          case compile_select(x, options) do
            nil -> acc
            bin -> <<bin :: binary, " ">>
          end
        end
    end

    defp pool, do: Application.environment(:saloon)[:emysql_pool]

    defp compile_select(:what, _opt), do: nil
    defp compile_select(:from, _opt), do: nil
    defp compile_select(:join, _opt), do: nil
    defp compile_select(:left_join, _opt), do: nil
    defp compile_select(:right_join, _opt), do: nil
    defp compile_select(:where, _opt), do: nil
    defp compile_select(:group, _opt), do: nil
    defp compile_select(:order, _opt), do: nil
    defp compile_select(:limit, _opt), do: nil
  end
end
