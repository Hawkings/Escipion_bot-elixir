defmodule Escipion.Application do
  use Application

  def start(_type, _args),
    do: Supervisor.start_link(children(), opts())

  defp children do
    [
      Escipion.Telegram.Server.Http
    ]
  end

  defp opts do
    [
      strategy: :one_for_one,
      name: Escipion.Supervisor
    ]
  end
end
