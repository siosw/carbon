defmodule Carbon.GapsScheduler do
  use GenServer
  require Logger

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(_args) do
    Logger.info "GapsScheduler initialized"
    schedule_work()
    {:ok, "✅"}
  end

  def handle_info(:work, state) do
    do_work()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 10 * 1000)
  end

  defp do_work() do
    num_datapoints = Carbon.Gaps.get()

    Logger.info "trying to fill gaps..."
    Logger.info "filled #{num_datapoints} gaps"
  end
end
