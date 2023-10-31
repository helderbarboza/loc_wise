defmodule LocWiseWeb.ImportLive do
  use LocWiseWeb, :live_view

  import LocWiseWeb.ContentTypography
  import LocWiseWeb.Spinner

  alias LocWise.Import

  attr :started, :boolean
  attr :done, :boolean

  def render(assigns) do
    ~H"""
    <div class="border-b pb-4 mb-8 border-gray-200">
      <.h1>Import</.h1>
    </div>
    <.p>Fetches updated data from IBGE's API.</.p>
    <.p>
      This action will only import the missing items into the database, looking for their <span class="font-semibold">code</span>. Existing items will not be replaced.
    </.p>

    <div class="flex justify-between items-center">
      <div :if={@started and !@done} class="flex gap-2 items-center">
        <.spinner /> Importing! Please wait...
      </div>
      <div :if={@done} class="flex gap-2 items-center">
        <.icon name="check" class="w-8 h-8 mr-2 text-emerald-500" />
        Done! <%= @states_count %> states, <%= @cities_count %> cities imported.
      </div>
      <.button
        disabled={@started}
        phx-click={JS.push("import")}
        class="ml-auto"
        data-confirm="Are you sure?"
      >
        Start import
      </.button>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    socket = assign(socket, started: false, done: false)

    {:ok, socket}
  end

  def handle_event("import", _params, socket) do
    socket =
      socket
      |> start_async(:imported, fn ->
        Import.import()
      end)
      |> assign(:started, true)

    {:noreply, socket}
  end

  def handle_async(:imported, {:ok, counts}, socket) do
    socket =
      socket
      |> assign(:done, true)
      |> assign(:states_count, counts.states_count)
      |> assign(:cities_count, counts.cities_count)
      |> put_flash(:info, "Import done.")

    {:noreply, socket}
  end
end
