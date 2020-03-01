defmodule Escipion.Telegram.Client.PollingAgent do
  use Agent

  def child_spec([]) do
    interval = Application.get_env(:escipion_bot, :polling_interval)
    child_spec([interval])
  end

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  @spec start_link([integer]) :: {:ok, pid}
  def start_link([milliseconds]) do
    return = Agent.start_link(fn -> milliseconds end, name: __MODULE__)
    spawn(&poll_loop/0)
    return
  end

  defp poll_loop(offset \\ 0) do
    t1 = DateTime.utc_now() |> DateTime.to_unix(:millisecond)
    time = Agent.get(__MODULE__, & &1)

    new_offset =
      case time do
        x when x <= 0 ->
          :timer.sleep(10_000)
          offset

        _ ->
          new_offset =
            Escipion.Telegram.Client.Protocol.get_updates(offset)
            |> Escipion.Telegram.UpdateProcessor.process_updates()

          t2 = DateTime.utc_now() |> DateTime.to_unix(:millisecond)
          delta = max(0, time - (t2-t1))
          :timer.sleep(delta)
          new_offset && (new_offset + 1) || offset
      end

    poll_loop(new_offset)
  end

  @spec update_interval(integer) :: :ok
  def update_interval(milliseconds) do
    Agent.update(__MODULE__, fn _ -> milliseconds end)
  end

  @spec disable_polling :: :ok
  def disable_polling do
    Agent.update(__MODULE__, fn _ -> 0 end)
  end
end
