defmodule Escipion.Telegram.Server.Router do
  alias Escipion.Telegram.UpdateProcessor
  use Plug.Router

  plug(:match)

  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: {Poison, :decode!, [[keys: :atoms]]}
  )

  plug(:dispatch)

  post "/#{Application.get_env(:escipion_bot, :secret_path)}" do
    UpdateProcessor.process_updates(conn.body_params)
    send_resp(conn, 200, "")
  end

  match _ do
    send_resp(conn, 404, "Requested page not found!")
  end


end
