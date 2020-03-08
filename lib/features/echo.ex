defmodule Escipion.Features.Echo do
  alias Escipion.Dal.Repo
  alias Escipion.Telegram.Client.Protocol, as: Telegram

  def run(%{message: msg}) do
    do_echo(msg)
  end

  def run(_) do
  end

  defp do_echo(%{
    chat: %{id: chat_id},
    text: msg,
    from: %{id: user_id}
  }) do
    count = Repo.increase_message_count(user_id)
    Telegram.send_message(chat_id, "#{count}: #{msg}")
  end

  defp do_echo(_) do
  end
end
