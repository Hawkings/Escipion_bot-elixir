defmodule ThrottlingTest do
  @moduledoc """
  Tests for the Throttling class
  """
  use ExUnit.Case
  alias Escipion.Telegram.Client.Throttling, as: Throttling

  test "sends message after timeout" do
    {:ok, pid} = GenServer.start_link(Throttling, %{
      timeout: 1,
      callback: fn item -> IO.puts(item) end,
    })
    GenServer.cast(pid, {:push, "asdf"})
    GenServer.cast(pid, :pop)
    :timer.sleep 101
  end
end
