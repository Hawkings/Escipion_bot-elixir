defmodule Escipion.Dal.User do
  alias Escipion.Dal.User

  defstruct [:user_id, :chat_id, :name, :pole_score]

  defguard is_pole_position(pos) when 3 >= pos and pos >= 1

  defp position_to_score(pos) when is_pole_position(pos) do
    7 - pos * 2
  end

  defp position_to_score(_) do
    0
  end

  def increase_pole_score(u = %User{pole_score: p}, pos) do
    %User{u | pole_score: p + position_to_score(pos)}
  end
end
