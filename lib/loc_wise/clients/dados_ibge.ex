defmodule LocWise.Clients.DadosIBGE do
  use Tesla
  use Nebulex.Caching

  alias LocWise.LocalCache, as: Cache

  plug Tesla.Middleware.BaseUrl, "https://servicodados.ibge.gov.br/api"
  plug Tesla.Middleware.JSON

  @ttl :timer.hours(1)

  @decorate cacheable(cache: Cache, opts: [ttl: @ttl], match: match())
  def get_states, do: get("/v1/localidades/estados")

  @decorate cacheable(cache: Cache, opts: [ttl: @ttl], match: match())
  def get_cities, do: get("/v1/localidades/municipios")

  @decorate cacheable(cache: Cache, opts: [ttl: @ttl], match: match())
  def get_cities_by_state(uf), do: get("/v1/localidades/estados/#{uf}/municipios")

  defp match, do: &match?({:ok, %{status: 200}}, &1)
end
