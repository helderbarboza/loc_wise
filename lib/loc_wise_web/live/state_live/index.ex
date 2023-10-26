defmodule LocWiseWeb.StateLive.Index do
  use LocWiseWeb, :live_view

  import LocWiseWeb.Link

  alias LocWise.Locations
  alias LocWise.Locations.State

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :states, Locations.list_states())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
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

  @impl true
  def handle_info({LocWiseWeb.StateLive.FormComponent, {:saved, state}}, socket) do
    {:noreply, stream_insert(socket, :states, state)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    state = Locations.get_state!(id)
    {:ok, _} = Locations.delete_state(state)

    {:noreply, stream_delete(socket, :states, state)}
  end
end
