defmodule LocWise.IBGE do
  alias LocWise.Clients.SidraIBGE

  def population_by_city(%{code: id} = _city) do
    {:ok, %{body: items}} = SidraIBGE.get_population_by_city(id)

    items |> parse_rows() |> hd()
  end

  def pib_by_city(%{code: id} = _city) do
    {:ok, %{body: items}} = SidraIBGE.get_pib_by_city(id)

    items |> parse_rows() |> hd()
  end

  defp parse_rows([header | items]) do
    Enum.map(items, fn item ->
      Map.new(item, fn {k, v} -> {header[k], v} end)
    end)
  end
end
