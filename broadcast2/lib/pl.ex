defmodule Pl do

  def start(c) do
    receive do
      { :bind, index, pl_map } ->
        send c, { :ur_pl, self()}
        next(pl_map, index, c)
    end
  end

  def next(pl_map, index, c) do

    receive do

      { :pl_send, {:broadcast, _, _ } = msg } ->
        send c, msg
        next(pl_map, index, c)

      { :pl_send, to, msg } ->
        send pl_map[to], { :pl_deliver, msg }
        next(pl_map, index, c)

      { :pl_deliver, msg } ->
        send c, msg
        next(pl_map, index, c)
    end

  end
end
