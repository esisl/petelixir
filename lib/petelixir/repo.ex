defmodule Petelixir.Repo do
  use Ecto.Repo,
    otp_app: :petelixir,
    adapter: Ecto.Adapters.Postgres
end
