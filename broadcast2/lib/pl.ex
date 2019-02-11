defmodule Pl do

  def start(c) do
    receive do
      { :bind, index, pl_map } ->
        send c, { :ur_pl, pl_map}
        next(pl_map, index, c)
    end
  end

  def next(pl_map, index, c) do

    receive do

      { :pl_send, msg } ->
        send c, msg
        next(pl_map, index, c)

      { :pl_deliver, from } ->
        send c, { :update, from }
        next(pl_map, index, c)
    end

  end
end
