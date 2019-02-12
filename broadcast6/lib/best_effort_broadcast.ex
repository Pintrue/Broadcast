defmodule Best_effort_broadcast do

def start(processes) do
  receive do
    { :bind, pl, c } ->
      next(processes, pl, c, nil)
  end
end

def next(processes, pl, c, erb) do
  receive do

  { :your_erb, your_erb } ->
    next(processes, pl, c, your_erb)

  { :beb_broadcast, from, msg } ->
    for i <- 0..4 do
      send processes[i], { :pl_deliver, from, msg }
    end
    next(processes, pl, c, erb)

  { :beb_update, from, msg } ->
    send erb, { :beb_deliver, from, msg }
    next(processes, pl, c, erb)

  end

end

end
