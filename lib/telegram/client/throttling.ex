defmodule Escipion.Telegram.Client.Throttling do
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
  @spec init(%{
    timeout: integer,
    callback: (any -> any)})
    :: {:ok, state}
  def init(map) do
    {:ok, %{
      queue: :queue.new(),
      timeout: map[:timeout] || 100,
      callback: map[:callback] || fn -> nil end
    }}
  end

  @impl true
  def handle_cast({:push, item}, state) do
    if :queue.is_empty(state.queue) do
      Process.send_after(self(), :pop, state.timeout)
    end
    {:noreply, %{state | queue: :queue.in(item, state.queue)}}
  end

  @impl true
  def handle_info(:pop, state) do
    {{_, item}, q2} = :queue.out(state.queue)
    if not :queue.is_empty(q2) do
      Process.send_after(self(), :pop, state.timeout)
    end
    # TelegramClient.send_message(item.chat_id, item.msg)
    IO.puts("TEST OUTPUT ++#{item}++ TEST OUTPUT")
    state.callback.(item)
    {:noreply, %{state | queue: q2}}
  end
end
