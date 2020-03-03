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
    Plug.Adapters.Cowboy.https(Escipion.Telegram.Server.Router, [],
      port: 8443,
      otp_app: :escipion_bot,
      keyfile: "priv/ssl/key.pem",
      certfile: "priv/ssl/cert.pem"
    )
  rescue
    ArgumentError -> Plug.Adapters.Cowboy.http(Escipion.Telegram.Server.Router, [])
  end
end
