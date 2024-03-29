defmodule Broadcast do

def main do
  pls =
  for i <- 0..4 do
    spawn(Peer, :start, [i, self()])
    receive do
      {:plMsg, pl, index} ->
        {index, pl}
    end
  end

  pl_map = Enum.into(pls, %{})

  for {self_index, pl} <- pls do
    send pl, {:bind, self_index, pl_map}
  end

  for {_, pl} <- pls do
    send pl, { :pl_send, { :broadcast, 10000000, 6000 } }
  end

end

def main_net do
  pls =
  for i <- 0..4 do
    # Node.spawn(Peer, :start, [i, self()])
    Node.spawn(:'peer#{i}@peer#{i}.localdomain', Peer, :start, [i, self()])
    receive do
      {:plMsg, pl, index} ->
        {index, pl}
    end
  end

  pl_map = Enum.into(pls, %{})

  for {self_index, pl} <- pls do
    send pl, {:bind, self_index, pl_map}
  end

  for {_, pl} <- pls do
    send pl, { :pl_send, { :broadcast, 10000000, 6000 } }
  end

end

end
