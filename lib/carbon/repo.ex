defmodule Carbon.Repo do
  use Ecto.Repo,
    otp_app: :carbon,
    adapter: Ecto.Adapters.Postgres
end
