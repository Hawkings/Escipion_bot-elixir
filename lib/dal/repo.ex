defmodule Escipion.Dal.Repo do
  require Escipion.Dal.Pole
  require Escipion.Dal.User

  alias :mnesia, as: Mnesia
  alias Escipion.Dal.Pole
  alias Escipion.Dal.User

  def init!() do
    Mnesia.create_schema([node()])
    Mnesia.start()

    case Mnesia.create_table(User, attributes: [:id, :user], disc_copies: [node()]) do
      {:atomic, :ok} -> nil
      {:aborted, {:already_exists, _}} -> nil
      {:aborted, reason} -> raise inspect(reason)
    end

    case Mnesia.create_table(Pole, attributes: [:id, :pole], disc_copies: [node()]) do
      {:atomic, :ok} -> nil
      {:aborted, {:already_exists, _}} -> nil
      {:aborted, reason} -> raise inspect(reason)
    end
  end

  def new_user?(pk) do
    case Mnesia.dirty_read({User, pk}) do
      [] -> true
      _ -> false
    end
  end

  def create_user(pk = {user_id, chat_id}, name) do
    Mnesia.dirty_write(
      {User, pk, %User{user_id: user_id, chat_id: chat_id, name: name, pole_score: 0}}
    )
  end

  defp read_pole(pole_id) do
    case Mnesia.read({Pole, pole_id}) do
      [{_, _, pole}] -> pole
      _ -> %Pole{next_pole: 1}
    end
  end

  def pole(pk, pole_id) when Pole.is_valid_pole(pole_id) do
    tx = fn ->
      pole = read_pole(pole_id)

      case pole.next_pole do
        pos when User.is_pole_position(pos) ->
          Mnesia.write({Pole, pole_id, %Pole{pole | next_pole: pole.next_pole + 1}})

          [{_, _, user}] = Mnesia.wread({User, pk})

          new_user = user |> User.increase_pole_score(pos)
          Mnesia.write({User, pk, new_user})

          new_user.pole_score
        _ ->
          nil
      end
    end

    {:atomic, pole_score} = Mnesia.transaction(tx)
    pole_score
  end

  def reset_pole(pole_id) when Pole.is_valid_pole(pole_id) do
    Mnesia.dirty_write({Pole, pole_id, %Pole{next_pole: 1}})
  end
end
