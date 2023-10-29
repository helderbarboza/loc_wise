defmodule LocWiseWeb.StateLive.Index do
  use LocWiseWeb, :live_view

  import LocWiseWeb.Link

  alias LocWise.Locations
  alias LocWise.Locations.State

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :states, [])}
  end

  @impl true
  def handle_params(params, _url, socket) do
    case Locations.list_states(params) do
      {:ok, {states, meta}} ->
        socket =
          socket
          |> assign(:meta, meta)
          |> stream(:states, states, reset: true)
          |> apply_action(socket.assigns.live_action, params)

        {:noreply, socket}

      {:error, _meta} ->
        {:noreply, push_navigate(socket, to: ~p"/states")}
    end
  end

  @impl true
  def handle_event("update-filter", params, socket) do
    params = Map.delete(params, "_target")
    {:noreply, push_patch(socket, to: ~p"/states?#{params}")}
  end

  @impl true
  def handle_event("paginate", %{"page" => page} = params, socket) do
    flop = Flop.set_page(socket.assigns.meta.flop, page)

    with {:ok, {states, meta}} <- Locations.list_states(flop) do
      params = Map.delete(params, "_target")

      socket =
        socket
        |> assign(:meta, meta)
        |> stream(:states, states, reset: true)
        |> push_patch(to: ~p"/states?#{params}")

      {:noreply, socket}
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    state = Locations.get_state!(id)
    {:ok, _} = Locations.delete_state(state)

    {:noreply, stream_delete(socket, :states, state)}
  end

  @impl true
  def handle_info({LocWiseWeb.StateLive.FormComponent, {:saved, state}}, socket) do
    {:noreply, stream_insert(socket, :states, state)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit State")
    |> assign(:state, Locations.get_state!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New State")
    |> assign(:state, %State{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "States")
    |> assign(:state, nil)
  end
end
