defmodule LocWise.Import do
  alias LocWise.Clients.DadosIBGE
  alias LocWise.Locations.City
  alias LocWise.Locations.State
  alias LocWise.Repo

  def import do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

    {:ok, %{status: 200, body: ibge_states}} = DadosIBGE.get_states()

    {states_count, _states} =
      ibge_states
      |> Enum.map(fn state ->
        region =
          case state["regiao"]["sigla"] do
            "N" -> :north
            "NE" -> :northeast
            "SE" -> :southeast
            "S" -> :south
            "CO" -> :midwest
          end

        %{
          name: state["nome"],
          acronym: state["sigla"],
          region: region,
          code: to_string(state["id"]),
          inserted_at: now,
          updated_at: now
        }
      end)
      |> then(&Repo.insert_all(State, &1, on_conflict: :nothing))

    states = Repo.all(State)

    {:ok, %{status: 200, body: ibge_cities}} = DadosIBGE.get_cities()

    {cities_count, _cities} =
      ibge_cities
      |> Enum.map(fn city ->
        state =
          Enum.find(
            states,
            &(&1.acronym == city["regiao-imediata"]["regiao-intermediaria"]["UF"]["sigla"])
          )

        %{
          name: city["nome"],
          state_id: state.id,
          code: to_string(city["id"]),
          inserted_at: now,
          updated_at: now
        }
      end)
      |> then(&Repo.insert_all(City, &1, on_conflict: :nothing))

    %{states_count: states_count, cities_count: cities_count}
  end
end
