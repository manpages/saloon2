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
      compile(:select, [:distinct, :what, :from, :join, :left_join, :right_join, :where, :group, :order, :limit], "SELECT ", options)
    end

    def insert(into, values, options // []) do
      options = [{:into, into} | options]
      options = [{:values, values} | options]
      compile(:insert, [:ignore, :into, :keys, :values], "INSERT ", options)
    end
    
    def update(table, set, where, options // []) do
      options = [{:table, table} | options]
      options = [{:set, set} | options]
      options = [{:where, where} | options]
      compile(:update, [:ignore, :table, :set, :where], "UPDATE ", options)
    end

    def delete(from, where, options // []) do
      options = [{:from, from} | options]
      options = [{:where, where} | options]
      compile(:delete, [:from, :where, :limit], "DELETE FROM ", options)
    end

    defp pool, do: Application.environment(:saloon)[:emysql_pool]

    defp compile(query_type, query_properties, acc0, options) do
      List.foldl query_properties, acc0, 
        fn x, acc ->
          case compile! query_type, x, options do
            nil -> acc
            bin -> <<acc :: binary, bin :: binary, " ">>
          end
        end

    end

    defp compile!(:select, :distinct, opt) do 
      if :proplists.get_value :distinct, opt, :false do
        "DISTINCT"
      end
    end
    defp compile!(:select, :what, opt) do 
      case :proplists.get_value :what, opt, :false do
        :false -> "*"
        fs -> implode! fs, ", "
      end
    end
    defp compile!(:select, :from, opt) do
      from = :proplists.get_value :from, opt
      <<"FROM ", from :: binary>>
    end
    defp compile!(:select, :join, opt), do: join! "INNER JOIN", :join, opt
    defp compile!(:select, :left_join, opt), do: join! "LEFT JOIN", :left_join, opt
    defp compile!(:select, :right_join, opt), do: join! "RIGHT JOIN", :right_join, opt
    defp compile!(:select, :where, opt) do
      case :proplists.get_value :where, opt, :false do #TODO: add kv-condition compiler
        false -> nil
        [and_gropup|and_gropus] when is_list(and_gropup) ->
          conditions = or!(Enum.map [and_gropup|and_gropus], and! &1)
          <<"WHERE ", conditions :: binary>>
        and_gropup ->
          conditions = and!(and_gropup)
          <<"WHERE ", conditions :: binary>>
      end
    end
    defp compile!(:select, :group, opt) do
      group = :proplists.get_value :group, opt, :false
      if group do
        <<"GROUP BY ", group :: binary>>
      end
    end
    defp compile!(:select, :order, opt) do
      case :proplists.get_value :order, opt, :false do
        false -> nil
        [{mode, fs}] when is_atom(mode) -> 
          fs = if is_list(fs), do: fs, else: [fs]
          fstr = implode! fs, ", "
          if mode == :desc do
            <<"ORDER BY ", fstr :: binary, " DESC">>
          else
            <<"ORDER BY ", fstr :: binary, " ASC">>
          end
        raw when is_binary(raw) -> <<"ORDER BY ", raw :: binary>>
      end
    end
    defp compile!(:select, :limit, opt) do
      case :proplists.get_value :limit, opt, :false do
        false -> nil
        {l,o} when is_binary(l) and is_binary(o) -> <<"LIMIT ", l :: binary, ", ", o ::binary>>
        int when is_binary(int) -> <<"LIMIT ", int :: binary>>
      end
    end
    
    defp compile!(:insert, :ignore, _opt), do: nil
    defp compile!(:insert, :into, _opt), do: nil
    defp compile!(:insert, :keys, _opt), do: nil
    defp compile!(:insert, :values, _opt), do: nil

    defp compile!(:update, :ignore, _opt), do: nil
    defp compile!(:update, :table, _opt), do: nil
    defp compile!(:update, :set, _opt), do: nil
    defp compile!(:update, :where, _opt), do: nil

    defp compile!(:delete, :from, _opt), do: nil
    defp compile!(:delete, :where, _opt), do: nil
    defp compile!(:delete, :limit, _opt), do: nil

    defp join!(text, type, opt) do
      case :proplists.get_value(type, opt, :false) do
        {rtable, {lfield, rfield}} -> 
          ltable = :proplists.get_value :from, opt
          <<text :: binary, " ", rtable :: binary, " ON ", 
            ltable :: binary, ".", lfield :: binary, " = ",
            rtable :: binary, ".", rfield :: binary, "">>
        raw: raw -> raw
        phrase when is_binary(phrase) -> <<text :: binary, " ", phrase :: binary>>
        _ -> nil
      end
    end

    defp or!([o|os]) do
      List.foldl os, o, fn x, acc0 -> 
        <<acc0 :: binary, " OR ", x :: binary>>
      end
    end

    defp and!([a|as]) do
      List.foldl as, a, fn x, acc0 -> 
        <<acc0 :: binary, " AND ", x :: binary>>
      end
    end

    defp implode!([f|fs], text) do
      List.foldl fs, f, fn x, acc0 -> <<acc0 :: binary, text :: binary, x :: binary>> end
    end

  end
end
