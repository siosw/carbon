defmodule Carbon.PastScheduler do
  use GenServer
  require Logger

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(_args) do
    Logger.info "PastScheduler initialized"
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
    num_datapoints = Carbon.Past.get(30)

    Logger.info "collecting past data..."
    Logger.info "got #{num_datapoints} past datapoints"
  end
end
