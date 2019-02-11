defmodule Peer do


  def start(index, server) do

    c = spawn(Com, :start, [index])
    pl = spawn(Pl, :start, [c])

    send server, {:plMsg, pl, index}

  end

end









#
#
#
#   def start(index) do
#     receive do
#     { :bind, peers } ->
#       counts = for i <- 0..4, into: %{}, do: {i, {0, 0}}
#       next(peers, counts, index)
#     end
#   end
#
#   def next(peers, counts, index) do
#     receive do
#       { :broadcast, max_broadcasts, timeout} ->
#         send self(), { :startSending, max_broadcasts}
#         Process.send_after(self(), :stop, timeout)
#         next(peers, counts, index)
#
#       { :startSending, max_broadcasts } ->
#         if max_broadcasts > 0 do
#           for i <- 0..4 do
#             # IO.puts "Peer #{index} send to Peer #{i}, #{max_broadcasts} times"
#             send Enum.at(peers, i), { :sendMsg, index}
#           end
#           send self(), {:startSending, max_broadcasts - 1}
#           temp = Enum.map(counts, fn ({idx, {send, rece}}) -> {idx, {send + 1, rece}} end)
#           counts = Enum.into(temp, %{})
#           next(peers, counts, index)
#         else
#           next(peers, counts, index)
#         end
#
#
#       { :sendMsg, idx } ->
#         # IO.puts "Peer #{index} receive from Peer #{idx}"
#         {send, rece} = counts[idx]
#         counts = Map.put(counts, idx, {send, rece + 1})
#         next(peers, counts, index)
#
#         :stop  ->
#         IO.puts "Peer #{index}: #{inspect(counts)}"
#         Process.sleep(:infinity)
#
#     end
#   end
#
#
# end
