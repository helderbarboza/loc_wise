defmodule LocWise.Clients.SidraIBGE do
  use Tesla
  use Nebulex.Caching

  alias LocWise.LocalCache, as: Cache

  plug Tesla.Middleware.BaseUrl, "https://apisidra.ibge.gov.br"
  plug Tesla.Middleware.JSON

  @ttl :timer.hours(1)

  @doc """
  Population by city.

  [Source.](https://sidra.ibge.gov.br/tabela/9514)
  """
  @decorate cacheable(cache: Cache, opts: [ttl: @ttl])
  def get_population_by_city(code),
    do: get("/values/t/9514/n6/#{code}/v/allxp/p/all/c2/6794/c287/100362/c286/113635")

  @doc """
  PIB by city.

  [Source.](https://sidra.ibge.gov.br/tabela/5938)
  """
  @decorate cacheable(cache: Cache, opts: [ttl: @ttl])
  def get_pib_by_city(code),
    do: get("/values/t/5938/n6/#{code}/v/37/p/last%201/d/v37%200")

  @doc """
  Population by state.

  [Source.](https://sidra.ibge.gov.br/tabela/9514)
  """
  @decorate cacheable(cache: Cache, opts: [ttl: @ttl])
  def get_population_by_state(code),
    do: get("/values/t/9514/n3/#{code}/v/allxp/p/all/c2/6794/c287/100362/c286/113635")

  @doc """
  PIB by state.

  [Source.](https://sidra.ibge.gov.br/tabela/5938)
  """
  @decorate cacheable(cache: Cache, opts: [ttl: @ttl])
  def get_pib_by_state(code),
    do: get("/values/t/5938/n3/#{code}/v/37/p/last%201/d/v37%200")
end
