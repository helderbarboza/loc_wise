defmodule LocWise.Repo do
  use Ecto.Repo,
    otp_app: :loc_wise,
    adapter: Ecto.Adapters.Postgres
end
