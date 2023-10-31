defmodule LocWiseWeb.CityLive.Index do
  use LocWiseWeb, :live_view

  import LocWiseWeb.Link

  alias LocWise.Locations
  alias LocWise.Locations.City

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :cities, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    case Locations.list_cities(params) do
      {:ok, {cities, meta}} ->
        socket =
          socket
          |> assign(:meta, meta)
          |> stream(:cities, cities, reset: true)
          |> apply_action(socket.assigns.live_action, params)

        {:noreply, socket}

      {:error, _meta} ->
        {:noreply, push_navigate(socket, to: ~p"/cities")}
    end
  end

  @impl true
  def handle_event("update-filter", params, socket) do
    params = Map.delete(params, "_target")
    {:noreply, push_patch(socket, to: ~p"/cities?#{params}")}
  end

  @impl true
  def handle_event("paginate", %{"page" => page} = params, socket) do
    flop = Flop.set_page(socket.assigns.meta.flop, page)

    with {:ok, {cities, meta}} <- Locations.list_cities(flop) do
      params = Map.delete(params, "_target")

      socket =
        socket
        |> assign(:meta, meta)
        |> stream(:cities, cities, reset: true)
        |> push_patch(to: ~p"/cities?#{params}")

      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id} = params, socket) do
    city = Locations.get_city!(id)
    {:ok, _} = Locations.delete_city(city)
    {:ok, {cities, meta}} = Locations.list_cities(params)

    socket =
      socket
      |> assign(:meta, meta)
      |> stream(:cities, cities, reset: true)

    {:noreply, socket}
  end

  @impl true
  def handle_info({LocWiseWeb.CityLive.FormComponent, {:saved, city}}, socket) do
    {:noreply, stream_insert(socket, :cities, city)}
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
    |> assign(:page_title, "Cities")
    |> assign(:city, nil)
  end
end
