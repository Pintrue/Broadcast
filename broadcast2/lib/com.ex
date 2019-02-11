defmodule Com do

  def start(index) do
    counts = for i <- 0..4, into: %{}, do: {i, {0, 0}}
    next(counts, index, %{})
  end

  def next(counts, index, pls) do
    receive do
      { :ur_pl, pl_map } ->
        next(counts, index, pl_map)

      { :broadcast, max_broadcasts, timeout} ->
        send self(), { :startSending, max_broadcasts}
        Process.send_after(self(), :stop, timeout)
        next(counts, index, pls)

      { :startSending, max_broadcasts } ->
        if max_broadcasts > 0 do
          counts =
          for i <- 0..4 do
            send pls[i], { :pl_deliver, index }
            {send, rece} = counts[i]
            {i,{send + 1, rece}}
          end

          counts = Enum.into(counts, %{})
          send self(), {:startSending, max_broadcasts - 1}
          # temp = Enum.map(counts, fn ({idx, {send, rece}}) -> {idx, {send + 1, rece}} end)
          # counts = Enum.into(temp, %{})
          next(counts, index, pls)
        else
          next(counts, index, pls)
        end

      { :update, from } ->
        {send, rece} = counts[from]
        counts = Map.put(counts, from, {send, rece + 1})
        next(counts, index, pls)


        :stop  ->
          IO.puts "Peer #{index}: #{inspect(counts)}"
          Process.sleep(:infinity)

    end
  end

end
