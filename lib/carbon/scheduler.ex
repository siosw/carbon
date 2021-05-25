defmodule Carbon.Scheduler do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def init(state) do
    schedule_work()
    {:ok, state}
  end

  def handle_info(:work, state) do
    do_recurrent_thing()
    schedule_work()
    {:noreply, state}
  end

  defp schedule_work() do
    Process.send_after(self(), :work, 180 * 1000)
  end

  defp do_recurrent_thing() do
    Carbon.Past.get(30)
    Carbon.Gaps.get()
  end
end
