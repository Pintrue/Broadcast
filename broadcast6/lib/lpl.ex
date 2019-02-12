defmodule Lpl do

  def start(c, reliability) do
    receive do
      { :bind, index, pl_map } ->
        send c, { :ur_pl, pl_map }
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

      { :pl_send, msg } ->
        rand = DAC.random(100)
        if rand <= reliability do
          send c, msg
        end
        next(pl_map, index, c, beb, reliability)

      { :pl_deliver, from, msg } ->
        rand = DAC.random(100)
        if rand <= reliability do
          send beb, { :beb_update, from, msg }
        end
        next(pl_map, index, c, beb, reliability)
    end

  end
end
