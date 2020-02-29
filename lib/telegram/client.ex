defmodule Escipion.Telegram.Client do
  require Logger

  @api_base "https://api.telegram.org"

  @spec bot_key :: String.t()
  def bot_key do
    Application.fetch_env!(:escipion_bot, :key)
  end

  @spec send_message(String.t(), String.t()) :: %{
          :__struct__ => HTTPoison.AsyncResponse | HTTPoison.Response,
          optional(:body) => any,
          optional(:headers) => [any],
          optional(:id) => reference,
          optional(:request) => HTTPoison.Request.t(),
          optional(:request_url) => any,
          optional(:status_code) => integer
        }
  def send_message(chat_id, msg) do
    body = %{
      chat_id: chat_id,
      text: msg
    }

    HTTPoison.post!(
      "#{@api_base}/bot#{bot_key()}/sendMessage",
      Poison.encode!(body),
      [{"Content-Type", "application/json"}]
    )
  end

  @spec get_updates() :: any
  def get_updates() do
    response = HTTPoison.post!(
      "#{@api_base}/bot#{bot_key()}/getUpdates",
      ""
    )
    Logger.info(response.body)
    response.body
  end
end
