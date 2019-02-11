defmodule Peer do


  def start(index, server) do

    c = spawn(Com, :start, [index])
    pl = spawn(Pl, :start, [c])

    send server, {:plMsg, pl, c, index}

  end

end
