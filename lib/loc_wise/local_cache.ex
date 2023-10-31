defmodule LocWise.LocalCache do
  @moduledoc """
  Local cache implementation for `Nebulex`.
  """

  @behaviour Nebulex.Caching.KeyGenerator

  use Nebulex.Cache,
    otp_app: :loc_wise,
    adapter: Nebulex.Adapters.Local,
    default_key_generator: __MODULE__

  @impl true
  def generate(mod, fun, args), do: :erlang.phash2({mod, fun, args})
end
