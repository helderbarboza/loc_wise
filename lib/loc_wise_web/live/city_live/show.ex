defmodule LocWiseWeb.CityLive.Show do
  use LocWiseWeb, :live_view

  import LocWiseWeb.ContentTypography

  alias LocWise.IBGE
  alias LocWise.Locations

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    city = Locations.get_city!(id)

    socket =
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:city, city)
      |> assign(:states_options, Locations.list_states_options())
      |> assign_async(:population, fn -> {:ok, %{population: IBGE.population_by_city(city)}} end)
      |> assign_async(:pib, fn -> {:ok, %{pib: IBGE.pib_by_city(city)}} end)
      |> assign_async(:area, fn -> {:ok, %{area: IBGE.territorial_area_by_city(city)}} end)
      |> assign_async(:demographic_density, fn ->
        {:ok, %{demographic_density: IBGE.demographic_density_by_city(city)}}
      end)

    {:noreply, socket}
  end

  defp page_title(:show), do: "Show City"
  defp page_title(:edit), do: "Edit City"
end
