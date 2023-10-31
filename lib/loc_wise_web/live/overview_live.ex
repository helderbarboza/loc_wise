defmodule LocWiseWeb.OverviewLive do
  use LocWiseWeb, :live_view

  import LocWiseWeb.ContentTypography

  alias LocWise.Locations

  def render(assigns) do
    ~H"""
    <.h1>Hi there!</.h1>

    <.p>
      Use the buttons on the sidebar to get started.
    </.p>

    <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
      <.live_component
        module={LocWiseWeb.StatCardComponent}
        id="states-card"
        icon_name="database"
        stat={@states}
        number_format_opts={[delimiter: " ", separator: ",", precision: 0]}
      />
      <.live_component
        module={LocWiseWeb.StatCardComponent}
        id="cities-card"
        icon_name="database"
        stat={@cities}
        number_format_opts={[delimiter: " ", separator: ",", precision: 0]}
      />
    </div>
    """
  end

  def mount(_params, _session, socket) do
    cities = Locations.count_cities()
    states = Locations.count_states()

    socket =
      socket
      |> assign(page_title: "Overview")
      |> assign_async([:cities, :states], fn ->
        {:ok,
         %{
           cities: %LocWise.SingleStat{value: cities, variable: "Cities"},
           states: %LocWise.SingleStat{value: states, variable: "States"}
         }}
      end)

    {:ok, socket}
  end
end
