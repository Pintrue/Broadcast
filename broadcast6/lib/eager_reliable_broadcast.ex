defmodule Eager_reliable_broadcast do

  def start do
    receive do
      {:bind, c, beb } -> next(c, beb, MapSet.new())
    end
  end

  def next(c, beb, delivered) do
    receive do
      { :erb_broadcast, msg } ->
        send beb, {:beb_broadcast, msg}
        next(c, beb, delivered)

      { :beb_deliver, msg } ->
        if msg in delivered do
          next(c, beb, delivered)
        else
          send c, msg
          send beb, { :beb_broadcast, msg }
          next(c, beb, MapSet.put(delivered, msg))
        end
    end
  end


end
