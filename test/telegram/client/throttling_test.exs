defmodule ThrottlingTest do
  @moduledoc """
  Tests for the Throttling class
  """
  use ExUnit.Case
  alias Escipion.Throttling, as: Throttling

  defmodule Counter do
    use Agent

    def start_link do
      Agent.start_link(fn -> 0 end, name: __MODULE__)
    end

    def get do
      Agent.get(__MODULE__, & &1)
    end

    def increment do
      Agent.update(__MODULE__, & (&1 + 1))
    end
  end

  test "counts correctly" do
    Counter.start_link
    assert Counter.get == 0
    Counter.increment
    assert Counter.get == 1
    Counter.increment
    assert Counter.get == 2
    assert Counter.get == 2
  end

  test "sends message after timeout" do
    Counter.start_link
    throttler = Throttling.init!(100)
    :ok = Throttling.throttle(throttler, &Counter.increment/0)
    :ok = Throttling.throttle(throttler, &Counter.increment/0)
    :ok = Throttling.throttle(throttler, &Counter.increment/0)
    assert Counter.get == 0
    :timer.sleep(110)
    assert Counter.get == 1
    :timer.sleep(110)
    assert Counter.get == 2
    :timer.sleep(110)
    assert Counter.get == 3
    :timer.sleep(110)
    assert Counter.get == 3
  end
end
