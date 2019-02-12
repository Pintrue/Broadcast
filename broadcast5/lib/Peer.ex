defmodule Peer do

  @pl_reliability 20

  def start(index, server) do

    c = spawn(Com, :start, [index])
    pl = spawn(Lpl, :start, [c, @pl_reliability])

    send server, {:plMsg, pl, c, index}

  end

end
