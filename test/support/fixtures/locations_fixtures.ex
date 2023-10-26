defmodule LocWise.LocationsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `LocWise.Locations` context.
  """

  @doc """
  Generate a state.
  """
  def state_fixture(attrs \\ %{}) do
    {:ok, state} =
      attrs
      |> Enum.into(%{
        acronym: "some acronym",
        name: "some name",
        region: :north
      })
      |> LocWise.Locations.create_state()

    state
  end
end
