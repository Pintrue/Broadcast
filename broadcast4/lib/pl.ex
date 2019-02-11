defmodule Pl do

  def start(c) do
    receive do
      { :bind, index, pl_map } ->
        send c, { :ur_pl, pl_map}
        next(pl_map, index, c, nil)
    end
  end

  def next(pl_map, index, c, beb) do

    receive do

      { :your_beb, b } ->
        next(pl_map, index, c, b)

      { :pl_send, msg } ->
        send c, msg
        next(pl_map, index, c, beb)

      { :pl_deliver, from } ->
        send beb, {:beb_update, from}
        next(pl_map, index, c, beb)
    end

  end
end
