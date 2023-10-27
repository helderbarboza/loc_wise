defmodule LocWise.IBGE do
  use Tesla
  use Nebulex.Caching

  alias LocWise.LocalCache, as: Cache

  plug Tesla.Middleware.BaseUrl, "https://servicodados.ibge.gov.br/api/v1/localidades"
  plug Tesla.Middleware.JSON

  @ttl :timer.hours(1)

  @decorate cacheable(cache: Cache)
  def states, do: get("/estados")
end
