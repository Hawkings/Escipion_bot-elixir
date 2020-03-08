defmodule Escipion.Dal.User do
  alias Escipion.Dal.User

  def set_msg_count({User, user_id, name, _}, count) do
    {User, user_id, name, count}
  end

  def get_msg_count({User, _, _, count}) do
    count
  end
end
