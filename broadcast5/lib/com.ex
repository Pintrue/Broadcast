defmodule Com do

  def start(index) do
    counts = for i <- 0..4, into: %{}, do: {i, {0, 0}}
    next(counts, index, nil)
  end

  def next(counts, index, beb) do
    receive do

      { :your_beb, your_beb} ->
        next(counts, index, your_beb)

      { :broadcast, max_broadcasts, timeout } ->
        send self(), { :startSending, max_broadcasts }
        if index == 3 do
          Process.send_after(self(), :terminate, 5)
        else
          Process.send_after(self(), :stop, timeout)
        end
        next(counts, index, beb)

      { :startSending, max_broadcasts } ->
        if max_broadcasts > 0 do
          send beb, { :beb_broadcast, { :update, index } }
          send self(), { :startSending, max_broadcasts - 1 }
          temp = Enum.map(counts, fn ({idx, {send, rece}}) -> {idx, {send + 1, rece}} end)
          counts = Enum.into(temp, %{})
          next(counts, index, beb)
        else
          next(counts, index, beb)
        end

      { :update, from } ->
        {send, rece} = counts[from]
        counts = Map.put(counts, from, {send, rece + 1})
        next(counts, index, beb)


        :stop  ->
          IO.puts "Peer #{index}: #{inspect(counts)}"
          Process.sleep(:infinity)

        :terminate ->
          IO.puts "Peer #{index} terminate"
          IO.puts "Peer #{index}: #{inspect(counts)}"
          Process.exit(self(), :kill)
    end
  end

end
