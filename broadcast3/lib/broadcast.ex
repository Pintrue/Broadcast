defmodule Broadcast do

def main do

  index_pl_c =
  for i <- 0..4 do
    spawn(Peer, :start, [i, self()])
    receive do
      {:plMsg, pl, c, index} ->
        {index, pl, c}
    end
  end

  pl_and_c =
    for {_, pl, c} <- index_pl_c do
      {pl, c}
    end

  pls =
    for {index, pl, _} <- index_pl_c do
      {index, pl}
    end


  pl_map = Enum.into(pls, %{})

  for {self_index, pl} <- pls do
    send pl, {:bind, self_index, pl_map}
  end

  for i <- 0..4 do
    b = spawn(Best_effort_broadcast, :start, [pl_map])
    {pl, c} = Enum.at(pl_and_c, i)
    send b, {:bind, pl, c}
    send c, {:your_beb, b}
    send pl, {:your_beb, b}
  end

  for {_, pl} <- pls do
    send pl, { :pl_send, { :broadcast, 1000, 3000 } }
  end

end

end
