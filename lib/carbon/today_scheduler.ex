defmodule Carbon.TodayScheduler do
  use GenServer
  require Logger

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(_args) do
    Logger.info "TodayScheduler initialized"
    schedule_work()
    {:ok, "✅"}
  end

  def handle_info(:work, state) do
    do_work()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    interval = Application.fetch_env!(:carbon, :today_interval)
    Process.send_after(self(), :work, interval)
  end

  defp do_work() do
    Logger.info "collecting todays data..."
    num_datapoints = Carbon.Today.get()

    Logger.info "got #{num_datapoints} datapoints from today"
  end
end
