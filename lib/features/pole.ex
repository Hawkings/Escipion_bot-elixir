defmodule Escipion.Features.Pole do
  alias Escipion.Dal.Repo
  alias Escipion.Telegram.Client.Protocol, as: Telegram

  def run(%{message: msg}) do
    do_pole(msg)
  end

  def run(_) do
  end

  defp do_pole(%{
    from: %{id: user_id, first_name: first_name, last_name: last_name},
    chat: %{id: chat_id},
    text: "pole",
  }) do
    score = Repo.pole({user_id, chat_id}, 3)
    Telegram.send_message(chat_id, "#{first_name} #{last_name} tu nuevo score es #{score}")
  end

  defp do_pole(_) do
  end
end
