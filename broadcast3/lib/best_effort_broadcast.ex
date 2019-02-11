defmodule Best_effort_broadcast do

def start(processes) do
  receive do
    { :bind, pl, c } ->
      next(processes, pl, c)
  end
end

def next(processes, pl, c) do
  receive do
  { :beb_broadcast, from } ->
    for i <- 0..4 do
      send processes[i], { :pl_deliver, from }
    end
    next(processes, pl, c)

  {:beb_update, from} ->
    send c, { :update, from }
    next(processes, pl, c)

  end

end

end
