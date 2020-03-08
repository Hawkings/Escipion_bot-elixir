defmodule Escipion.Dal.Repo do
  alias :mnesia, as: Mnesia
  alias Escipion.Dal.User
  @db User

  def init!() do
    Mnesia.create_schema([node()])
    Mnesia.start()

    case Mnesia.create_table(@db, attributes: [:id, :name, :msg_count], disc_copies: [node()]) do
      {:atomic, :ok} -> nil
      {:aborted, {:already_exists, _}} -> nil
      {:aborted, reason} -> raise inspect(reason)
    end
  end

  def new_user?(user_id) do
    case Mnesia.dirty_read({@db, user_id}) do
      [] -> true
      _ -> false
    end
  end

  def create_user(user_id, name) do
    Mnesia.dirty_write({@db, user_id, name, 0})
  end

  @spec increase_message_count(integer) :: integer
  def increase_message_count(user_id) do
    tx = fn ->
      [user] = Mnesia.wread({@db, user_id})
      count = User.get_msg_count(user)

      user
      |> User.set_msg_count(count + 1)
      |> Mnesia.write()

      count
    end

    {:atomic, count} = Mnesia.transaction(tx)
    count + 1
  end
end
