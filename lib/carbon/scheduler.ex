defmodule Carbon.Scheduler do
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(_args) do
    IO.puts "scheduler initialized"
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
    IO.inspect Carbon.Today.get()
    IO.puts "collecting past data"
    IO.inspect Carbon.Past.get(30)
    IO.puts "trying to fill gaps"
    IO.inspect Carbon.Gaps.get()
    IO.puts "done for now..."
  end
end
