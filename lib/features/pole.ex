defmodule Escipion.Features.Pole do
  alias Escipion.Dal.Repo
  alias Escipion.Telegram.Client.Protocol, as: Telegram

  def run(%{message: msg}) do
    do_pole(msg)
  end

  def run(_) do
  end

  defp get_pole_id(text) do
    case text do
      "pole rusa" -> :russian
      "pole andaluza" -> :andalusian
      "pole" -> :daily
      "pole secreta" -> :random
      "pole canaria" -> :canary
      _ -> nil
    end
  end

  defp do_pole(%{
         from: %{id: user_id, first_name: first_name, last_name: last_name},
         chat: %{id: chat_id},
         text: text
       }) do
    case get_pole_id(text) do
      nil ->
        nil
      id ->
        score = Repo.pole({user_id, chat_id}, id)
        Telegram.send_message(chat_id, "#{first_name} #{last_name} tu nuevo score es #{score}")
    end
  end

  defp do_pole(_) do
  end
end
