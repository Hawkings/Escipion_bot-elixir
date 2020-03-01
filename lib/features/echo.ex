defmodule Escipion.Features.Echo do
  def run(%{message: msg}) do
    do_echo(msg)
  end

  def run(_) do

  end

  defp do_echo(%{chat: %{id: chat_id}, text: msg}) do
    Escipion.Telegram.Client.Protocol.send_message(chat_id, msg)
  end

  defp do_echo(_) do

  end
end
