defmodule Escipion.Dal.Pole do
  alias Escipion.Dal.Repo

  defstruct [:next_pole]
  defguard is_valid_pole(pole_id) when pole_id in [:andalusian, :canarian, :daily, :random, :russian]

  @spec reset(:andalusian | :canarian | :daily | :random | :russian) :: :ok
  def reset(x) do
    Repo.reset_pole(x)
  end
end
