defmodule Pl do

  def start(c) do
    receive do
      { :bind, index, pl_map } ->
        next(pl_map, index, c, nil)
    end
  end

  def next(pl_map, index, c, beb) do

    receive do

      { :your_beb, b } ->
        next(pl_map, index, c, b)

      { :pl_send, { :broadcast, _, _ } = msg } ->
        send c, msg
        next(pl_map, index, c, beb)

      { :pl_send, from, msg} ->
        send pl_map[from], { :pl_deliver, msg }
        next(pl_map, index, c, beb)

      { :pl_deliver, msg } ->
        send beb, { :beb_update, msg }
        next(pl_map, index, c, beb)
    end

  end
end
