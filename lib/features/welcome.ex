defmodule Escipion.Features.Welcome do
  alias Escipion.Dal.Repo
  alias Escipion.Telegram.Client.Protocol, as: Telegram

  def run(%{message: msg}) do
    do_welcome(msg)
  end

  def run(_) do
  end

  defp do_welcome(%{
         chat: %{id: chat_id},
         from: %{first_name: first_name, last_name: last_name, id: user_id}
       }) do
    case Repo.new_user?(user_id) do
      true ->
        Telegram.send_message(chat_id, "Bienvenido #{first_name}#{last_name}")
        Repo.create_user(user_id, "#{first_name}#{last_name}")
      false -> nil
    end
  end

  defp do_welcome(_) do
  end
end
