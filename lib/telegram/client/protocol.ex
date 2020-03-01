defmodule Escipion.Telegram.Client.Protocol do
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

  @spec get_updates(integer) :: any
  def get_updates(offset \\ 0) do
    body = %{
      offset: offset,
      timeout: 45
    }

    response = HTTPoison.post!(
      "#{@api_base}/bot#{bot_key()}/getUpdates",
      Poison.encode!(body),
      [{"Content-Type", "application/json"}],
      [recv_timeout: 50_000]
    )
    Poison.decode!(response.body, %{keys: :atoms})
  end
end
