defmodule Com do

  def start(index) do
    counts = for i <- 0..4, into: %{}, do: {i, {0, 0}}
    next(counts, index, %{}, nil, nil)
  end

  def next(counts, index, pls, beb, erb) do
    receive do
      { :ur_pl, pl_map } ->
        next(counts, index, pl_map, beb, erb)
      { :your_beb, your_beb} ->
        next(counts, index, pls, your_beb, erb)
      { :your_erb, your_erb} ->
        next(counts, index, pls, beb, your_erb)

      { :broadcast, max_broadcasts, timeout} ->
        send self(), { :startSending, max_broadcasts}
        if index == 3 do
          Process.send_after(self(), :terminate, 5)
        else
          Process.send_after(self(), :stop, timeout)
        end
        next(counts, index, pls, beb, erb)

      { :startSending, max_broadcasts } ->
        if max_broadcasts > 0 do
          send erb, { :rb_broadcast, index, {index, max_broadcasts - 1}}
          send self(), { :startSending, max_broadcasts - 1 }
          temp = Enum.map(counts, fn ({idx, {send, rece}}) -> {idx, {send + 1, rece}} end)
          counts = Enum.into(temp, %{})
          next(counts, index, pls, beb, erb)
        else
          next(counts, index, pls, beb, erb)
        end

      { :update, from } ->
        {send, rece} = counts[from]
        counts = Map.put(counts, from, {send, rece + 1})
        next(counts, index, pls, beb, erb)


        :stop  ->
          IO.puts "Peer #{index}: #{inspect(counts)}"
          Process.sleep(:infinity)

        :terminate ->
          IO.puts "Peer #{index} terminate"
          Process.exit(self(), :exitEarly)

    end
  end

end
