defmodule LocWiseWeb.CityLive.Index do
  use LocWiseWeb, :live_view

  alias LocWise.Locations
  alias LocWise.Locations.City

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :cities, Locations.list_cities())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit City")
    |> assign(:states_options, Locations.list_states_options())
    |> assign(:city, Locations.get_city!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New City")
    |> assign(:states_options, Locations.list_states_options())
    |> assign(:city, %City{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Cities")
    |> assign(:city, nil)
  end

  @impl true
  def handle_info({LocWiseWeb.CityLive.FormComponent, {:saved, city}}, socket) do
    {:noreply, stream_insert(socket, :cities, city)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    city = Locations.get_city!(id)
    {:ok, _} = Locations.delete_city(city)

    {:noreply, stream_delete(socket, :cities, city)}
  end
end
