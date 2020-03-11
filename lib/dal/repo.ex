defmodule Escipion.Dal.Repo do
  alias :mnesia, as: Mnesia
  alias Escipion.Dal.User
  @db User

  def init!() do
    Mnesia.create_schema([node()])
    Mnesia.start()

    case Mnesia.create_table(@db, attributes: [:id, :user], disc_copies: [node()]) do
      {:atomic, :ok} -> nil
      {:aborted, {:already_exists, _}} -> nil
      {:aborted, reason} -> raise inspect(reason)
    end
  end

  def new_user?(pk) do
    case Mnesia.dirty_read({@db, pk}) do
      [] -> true
      _ -> false
    end
  end

  def create_user(pk = {user_id, chat_id}, name) do
    Mnesia.dirty_write({@db, pk, %User{user_id: user_id, chat_id: chat_id, name: name, pole_score: 0}})
  end

  def pole(pk, pos) do
    tx = fn ->
      [{_, _, user}] = Mnesia.wread({@db, pk})

      new_user = user |> User.increase_pole_score(pos)
      Mnesia.write({@db, pk, new_user})

      new_user.pole_score
    end

    {:atomic, pole_score} = Mnesia.transaction(tx)
    pole_score
  end
end
