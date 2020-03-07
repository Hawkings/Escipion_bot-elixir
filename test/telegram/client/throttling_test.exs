defmodule ThrottlingTest do
  @moduledoc """
  Tests for the Throttling class
  """
  use ExUnit.Case
  alias Escipion.Throttling, as: Throttling

  def do_receive(max_timeout) do
    receive do
      n -> n
    after
      max_timeout -> nil
    end
  end

  test "sends message after timeout" do
    this = self()

    callback = fn order ->
      send(this, order)
    end

    throttler = Throttling.init!(10)
    :ok = Throttling.throttle(throttler, fn -> callback.(1) end)
    :ok = Throttling.throttle(throttler, fn -> callback.(2) end)
    :ok = Throttling.throttle(throttler, fn -> callback.(3) end)

    assert nil == do_receive(9)
    assert 1 == do_receive(3)
    assert nil == do_receive(9)
    assert 2 == do_receive(3)
    assert nil == do_receive(9)
    assert 3 == do_receive(3)
  end
end
