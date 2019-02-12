defmodule Best_effort_broadcast do

def start(processes) do
  receive do
    { :bind, pl, c } ->
      next(processes, pl, c)
  end
end

def next(processes, pl, c) do
  receive do
  { :beb_broadcast, msg } ->
    for i <- 0..4 do
      send pl, { :pl_send, i, msg }
    end
    next(processes, pl, c)

  { :beb_deliver, msg } ->
    send c, msg
    next(processes, pl, c)

  end

end

end
