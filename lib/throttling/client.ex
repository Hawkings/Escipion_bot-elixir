defmodule Escipion.Throttling do
  @moduledoc """
  Module used to throttle the calls to the Telegram server
  """
  def init!(timeout \\ 100) do
    {:ok, pid} = GenServer.start_link(Escipion.Throttling.GenServer, timeout)
    pid
  end

  def throttle(throttler, callback) do
    GenServer.cast(throttler, {:push, callback})
  end
end
