defmodule Escipion.Telegram.Server.Http do
  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def init(state) do
    {:ok, state}
  end

  def start_link(_opts) do
    Plug.Adapters.Cowboy.http(Escipion.Telegram.Server.Router, [])
  end
end
