defmodule Carbon.TodayScheduler do
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(_args) do
    IO.puts "TodayScheduler initialized"
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
    IO.puts "collecting todays data"
    IO.puts "got #{Carbon.Today.get()} datapoints from today"
  end
end
