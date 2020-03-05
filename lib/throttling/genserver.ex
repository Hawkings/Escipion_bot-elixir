defmodule Escipion.Throttling.GenServer do
  @moduledoc """
  Module used to throttle the calls to the Telegram server
  """
  use GenServer
  # alias Escipion.Telegram.Client.Protocol, as: TelegramClient

  @type state :: %{
    queue: :queue.queue(any),
    timeout: integer,
    callback: (any -> any)
  }

  @impl true
  @spec init(integer) :: {:ok, %{queue: :queue.queue(any), timeout: integer}}
  def init(timeout) do
    {:ok, %{
      queue: :queue.new(),
      timeout: timeout,
    }}
  end

  @impl true
  def handle_cast({:push, callback}, state) do
    if :queue.is_empty(state.queue) do
      Process.send_after(self(), :pop, state.timeout)
    end
    {:noreply, %{state | queue: :queue.in(callback, state.queue)}}
  end

  @impl true
  def handle_info(:pop, state) do
    {{_, callback}, q2} = :queue.out(state.queue)
    if not :queue.is_empty(q2) do
      Process.send_after(self(), :pop, state.timeout)
    end

    spawn callback

    {:noreply, %{state | queue: q2}}
  end
end
