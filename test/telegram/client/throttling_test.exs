defmodule ThrottlingTest do
  @moduledoc """
  Tests for the Throttling class
  """
  use ExUnit.Case
  alias Escipion.Throttling, as: Throttling

  test "sends message after timeout" do
    throttler = Throttling.init!(1)
    :ok = Throttling.throttle(throttler, fn -> IO.puts("test") end)

    :timer.sleep(101)
  end
end
