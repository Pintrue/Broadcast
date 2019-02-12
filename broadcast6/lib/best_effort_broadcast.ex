defmodule Best_effort_broadcast do

def start(processes) do
  receive do
    { :bind, pl } ->
      next(processes, pl, nil)
  end
end

def next(processes, pl, erb) do
  receive do

  { :your_erb, your_erb } ->
    next(processes, pl, your_erb)

  { :beb_broadcast, msg } ->
    for i <- 0..4 do
      send pl, { :pl_send, i, msg }
    end
    next(processes, pl, erb)

  { :beb_update, msg } ->
    send erb, { :beb_deliver, msg }
    next(processes, pl, erb)

  end

end

end
