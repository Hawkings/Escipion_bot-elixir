defmodule Escipion.Application do
  use Application
  alias Escipion.Dal.Repo

  def start(_type, _args) do
    Repo.init!()
    HTTPoison.start()
    Supervisor.start_link(children(), opts())
  end

  defp children do
    [
      Escipion.Telegram.Server.Http,
      Escipion.Telegram.Client.PollingAgent,
      Escipion.Cron.Scheduler
    ]
  end

  defp opts do
    [
      strategy: :one_for_one,
      name: Escipion.Supervisor
    ]
  end
end
