defmodule Carbon.Application do
  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    children = [
      {Carbon.Repo, []}
    ]

    opts = [strategy: :one_for_one, name: Carbon.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
