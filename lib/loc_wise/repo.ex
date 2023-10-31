defmodule LocWise.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :loc_wise,
    adapter: Ecto.Adapters.Postgres
end
