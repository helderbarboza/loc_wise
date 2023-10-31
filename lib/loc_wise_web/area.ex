defmodule LocWiseWeb.Area do
  @moduledoc """
  Assigns the current area to the connection.
  """

  import Plug.Conn

  @areas [:internal, :external]

  def put_area(conn, area), do: assign(conn, :current_area, area)

  def on_mount(area, _params, _session, socket) when area in @areas do
    {:cont, Phoenix.Component.assign_new(socket, :current_area, fn -> area end)}
  end
end
