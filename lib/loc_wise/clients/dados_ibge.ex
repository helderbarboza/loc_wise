defmodule LocWise.Clients.DadosIBGE do
  @moduledoc """
  Functions to use IBGE's [data service API](https://servicodados.ibge.gov.br/api/docs).
  """
  use Tesla
  use Nebulex.Caching

  alias LocWise.LocalCache, as: Cache

  plug Tesla.Middleware.BaseUrl, "https://servicodados.ibge.gov.br/api"
  plug Tesla.Middleware.JSON

  @ttl :timer.hours(1)

  @doc """
  States.

  [Source](https://servicodados.ibge.gov.br/api/docs/localidades#api-UFs-estadosGet).
  """
  @decorate cacheable(cache: Cache, opts: [ttl: @ttl], match: match())
  def get_states, do: get("/v1/localidades/estados")

  @doc """
  Cities.

  [Source](https://servicodados.ibge.gov.br/api/docs/localidades#api-Municipios-municipiosGet).
  """
  @decorate cacheable(cache: Cache, opts: [ttl: @ttl], match: match())
  def get_cities, do: get("/v1/localidades/municipios")

  @doc """
  Mesh metadata by city.

  [Source](https://servicodados.ibge.gov.br/api/docs/malhas?versao=3#api-Metadados-municipiosIdMetadadosGet).
  """
  @decorate cacheable(cache: Cache, opts: [ttl: @ttl], match: match())
  def get_mesh_metadata_by_city(id), do: get("/v3/malhas/municipios/#{id}/metadados")

  @doc """
  Cities by UF (Federation Unit).

  [Source](https://servicodados.ibge.gov.br/api/docs/localidades#api-Municipios-estadosUFMunicipiosGet).
  """
  @decorate cacheable(cache: Cache, opts: [ttl: @ttl], match: match())
  def get_cities_by_state(id), do: get("/v1/localidades/estados/#{id}/municipios")

  @doc """
  Mesh metadata by state.

  [Source](https://servicodados.ibge.gov.br/api/docs/malhas?versao=3#api-Metadados-estadosIdMetadadosGet).
  """
  @decorate cacheable(cache: Cache, opts: [ttl: @ttl], match: match())
  def get_mesh_metadata_by_state(id), do: get("/v3/malhas/estados/#{id}/metadados")

  defp match, do: &match?({:ok, %{status: 200}}, &1)
end
