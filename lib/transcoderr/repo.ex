defmodule Transcoderr.Repo do
  use Ecto.Repo,
    otp_app: :transcoderr,
    adapter: Ecto.Adapters.Postgres
end
