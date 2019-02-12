defmodule Eager_reliable_broadcast do

  def start do
    receive do
      {:bind, c, beb } -> next(c, beb, MapSet.new())
    end
  end

  def next(c, beb, delivered) do
    receive do
      { :rb_broadcast, from, msg } ->
        send beb, { :beb_broadcast, from, msg }
        next(c, beb, delivered)

      { :beb_deliver, from, msg } ->
        if msg in delivered do
          next(c, beb, delivered)
        else
          send c, { :update, from }
          send beb, { :beb_broadcast, from, msg }
          next(c, beb, MapSet.put(delivered, msg))
        end
    end
  end


end
