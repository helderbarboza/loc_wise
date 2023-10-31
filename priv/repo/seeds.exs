# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     LocWise.Repo.insert!(%LocWise.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias LocWise.Clients.DadosIBGE
alias LocWise.Locations.City
alias LocWise.Locations.State
alias LocWise.Repo

now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)

{:ok, %{status: 200, body: ibge_states}} = DadosIBGE.get_states()

{_count, states} =
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
      code: state["id"],
      inserted_at: now,
      updated_at: now
    }
  end)
  |> then(&Repo.insert_all(State, &1, returning: true))

{:ok, %{status: 200, body: ibge_cities}} = DadosIBGE.get_cities()

Enum.map(ibge_cities, fn city ->
  state =
    Enum.find(
      states,
      &(&1.acronym == city["regiao-imediata"]["regiao-intermediaria"]["UF"]["sigla"])
    )

  %{
    name: city["nome"],
    state_id: state.id,
    code: city["id"],
    inserted_at: now,
    updated_at: now
  }
end)
|> then(&Repo.insert_all(City, &1))
