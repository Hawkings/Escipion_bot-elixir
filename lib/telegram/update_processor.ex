defmodule Escipion.Telegram.UpdateProcessor do
  # alias Escipion.Features.Echo
  alias Escipion.Features.Pole
  alias Escipion.Features.Welcome

  @spec process_updates(%{result: []}) :: nil
  def process_updates(%{result: []}) do
    nil
  end

  @spec process_updates(%{result: [...]}) :: integer
  def process_updates(%{result: updates}) do
    updates
    |> Enum.map(&process_update/1)
    |> Enum.max()
  end

  def process_update(update) do
    # TODO: run all features
    Welcome.run(update)
    # Echo.run(update)
    Pole.run(update)
    update.update_id
  end
end
