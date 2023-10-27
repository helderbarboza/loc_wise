defmodule LocWise.LocalCache do
  use Nebulex.Cache,
    otp_app: :loc_wise,
    adapter: Nebulex.Adapters.Local
end
