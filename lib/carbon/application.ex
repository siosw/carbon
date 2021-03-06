defmodule Carbon.Application do
  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    children = [
      {Carbon.Repo, []},
      {Carbon.TodayScheduler, []},
      {Carbon.PastScheduler, []},
      {Carbon.GapsScheduler, []},
    ]

    opts = [strategy: :one_for_one, name: Carbon.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
