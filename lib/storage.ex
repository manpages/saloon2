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
      compile(:select, [:what, :from, :join, :left_join, :right_join, :where, :group, :order, :limit], "SELECT ", options)
    end

    def insert(into, values, options // []) do
      options = [{:into, into} | options]
      options = [{:values, values} | options]
      compile(:insert, [:ignore, :into, :keys, :values], "INSERT ", options)
    end

    defp pool, do: Application.environment(:saloon)[:emysql_pool]

    defp compile(query_type, query_properties, acc0, options) do
      List.foldl query_properties, acc0, 
        fn x, acc ->
          case compile! query_type, x, options do
            nil -> acc
            bin -> <<bin :: binary, " ">>
          end
        end

    end

    defp compile!(:select, :what, _opt), do: nil
    defp compile!(:select, :from, _opt), do: nil
    defp compile!(:select, :join, _opt), do: nil
    defp compile!(:select, :left_join, _opt), do: nil
    defp compile!(:select, :right_join, _opt), do: nil
    defp compile!(:select, :where, _opt), do: nil
    defp compile!(:select, :group, _opt), do: nil
    defp compile!(:select, :order, _opt), do: nil
    defp compile!(:select, :limit, _opt), do: nil
    defp compile!(:insert, :ignore, _opt), do: nil
    defp compile!(:insert, :into, _opt), do: nil
    defp compile!(:insert, :keys, _opt), do: nil
    defp compile!(:insert, :values, _opt), do: nil

  end
end
