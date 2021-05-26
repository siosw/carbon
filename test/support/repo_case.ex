defmodule Carbon.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Carbon.Repo

      import Ecto
      import Ecto.Query
      import Carbon.RepoCase

    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Carbon.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Carbon.Repo, {:shared, self()})
    end

    :ok
  end
end
