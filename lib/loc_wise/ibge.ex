defmodule LocWise.IBGE do
  @moduledoc """
  Decodes data obtained from external APIs and wraps it on a struct.
  """

  alias LocWise.Clients.DadosIBGE
  alias LocWise.Clients.SidraIBGE
  alias LocWise.SingleStat

  def population_by_city(%{code: id} = _city) do
    {:ok, %{body: body}} = SidraIBGE.get_population_by_city(id)

    body
    |> parse_sidra()
    |> build_stat()
  end

  def pib_by_city(%{code: id} = _city) do
    {:ok, %{body: body}} = SidraIBGE.get_pib_by_city(id)

    body
    |> parse_sidra()
    |> build_stat()
  end

  def territorial_area_by_city(%{code: id} = _city) do
    {:ok, %{body: [item]}} = DadosIBGE.get_mesh_metadata_by_city(id)

    %SingleStat{
      unit: item["area"]["unidade"]["nome"],
      year: nil,
      variable: "Área territorial",
      value: item["area"]["dimensao"]
    }
  end

  def demographic_density_by_city(city) do
    %{value: population, year: year} = population_by_city(city)
    %{value: area} = territorial_area_by_city(city)

    densitity = Decimal.div(population, area)

    %SingleStat{
      unit: "habitantes/quilômetro quadrado",
      year: year,
      variable: "Densidade demográfica",
      value: densitity
    }
  end

  def population_by_state(%{code: id} = _state) do
    {:ok, %{body: body}} = SidraIBGE.get_population_by_state(id)

    body
    |> parse_sidra()
    |> build_stat()
  end

  def pib_by_state(%{code: id} = _state) do
    {:ok, %{body: body}} = SidraIBGE.get_pib_by_state(id)

    body
    |> parse_sidra()
    |> build_stat()
  end

  def territorial_area_by_state(%{code: id} = _state) do
    IO.inspect(id)
    {:ok, %{body: [item]}} = DadosIBGE.get_mesh_metadata_by_state(id)

    %SingleStat{
      unit: item["area"]["unidade"]["nome"],
      year: nil,
      variable: "Área territorial",
      value: item["area"]["dimensao"]
    }
  end

  def demographic_density_by_state(state) do
    %{value: population, year: year} = population_by_state(state)
    %{value: area} = territorial_area_by_state(state)

    densitity = Decimal.div(population, area)

    %SingleStat{
      unit: "habitantes/quilômetro quadrado",
      year: year,
      variable: "Densidade demográfica",
      value: densitity
    }
  end

  defp parse_sidra([header, item]) do
    Map.new(item, fn {k, v} -> {header[k], v} end)
  end

  defp build_stat(item) do
    %SingleStat{
      unit: Map.fetch!(item, "Unidade de Medida"),
      year: Map.fetch!(item, "Ano"),
      variable: Map.fetch!(item, "Variável"),
      value: Map.fetch!(item, "Valor")
    }
  end
end
