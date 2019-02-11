defmodule Broadcast do

def main do

  peers = for i <- 0..4, do: spawn(Peer, :start, [i])

  for p <- peers, do: send p, {:bind, peers}

  for p <- peers, do: send p, {:broadcast, 1000, 3000}

end

end
