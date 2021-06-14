defmodule Carbon.PastScheduler do
  use GenServer
  require Logger

  # chosen at random
  @number_of_days 30

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
    interval = Application.fetch_env!(:carbon, :past_interval)
    Process.send_after(self(), :work, interval)
  end

  defp do_work() do
    num_datapoints = Carbon.Past.get(@number_of_days)

    Logger.info "collecting past data..."
    Logger.info "got #{num_datapoints} past datapoints"
  end
end
