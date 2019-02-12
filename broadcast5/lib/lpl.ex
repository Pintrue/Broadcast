defmodule Lpl do

  def start(c, reliability) do
    receive do
      { :bind, index, pl_map } ->
        next(pl_map, index, c, nil, reliability)
    end
  end

  def next(pl_map, index, c, beb, reliability) do

    receive do

      { :your_beb, b } ->
        next(pl_map, index, c, b, reliability)

      { :pl_send, { :broadcast, _, _ } = msg } ->
        send c, msg
        next(pl_map, index, c, beb, reliability)

      { :pl_send, from, msg} ->
        rand = DAC.random(100)
        if rand <= reliability do
          send pl_map[from], { :pl_deliver, msg }
        end
        next(pl_map, index, c, beb, reliability)

      { :pl_deliver, msg } ->
        send beb, { :beb_update, msg }
        next(pl_map, index, c, beb, reliability)
    end

  end
end
