defmodule Escipion.Telegram.UpdateProcessor do
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

  defp process_update(update) do
    # TODO: run all features
    Escipion.Features.Echo.run(update)
    update.update_id
  end
end
