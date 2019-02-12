defmodule Peer do

  @pl_reliability 100

  def start(index, server) do

    c = spawn(Com, :start, [index])
    lpl = spawn(Lpl, :start, [c, @pl_reliability])

    send server, { :plMsg, lpl, c, index }

  end

end
