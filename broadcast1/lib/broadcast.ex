defmodule Broadcast do

# for local run
def main do
  # peers = for i <- 0..4, do: spawn(Peer, :start, [i])
  
  # for p <- peers, do: send p, {:bind, peers}
  # for p <- peers, do: send p, {:broadcast, 10000000, 6000}

end

# for docker run
def main_net do
  peers = for i <- 0..4, do: Node.spawn(:'peer#{i}@peer#{i}.localdomain', Peer, :start, [i])

  for p <- peers, do: send p, {:bind, peers}
  for p <- peers, do: send p, {:broadcast, 1000, 3000}
end

end
