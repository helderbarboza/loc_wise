defmodule LocWiseWeb.StateLive.Show do
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
    state = Locations.get_state!(id)

    socket =
      socket
      |> assign(:page_title, page_title(socket.assigns.live_action))
      |> assign(:state, state)
      |> assign_async(:population, fn -> {:ok, %{population: IBGE.population_by_state(state)}} end)
      |> assign_async(:pib, fn -> {:ok, %{pib: IBGE.pib_by_state(state)}} end)
      |> assign_async(:area, fn -> {:ok, %{area: IBGE.territorial_area_by_state(state)}} end)
      |> assign_async(:demographic_density, fn ->
        {:ok, %{demographic_density: IBGE.demographic_density_by_state(state)}}
      end)

    {:noreply, socket}
  end

  defp page_title(:show), do: "Show State"
  defp page_title(:edit), do: "Edit State"
end
