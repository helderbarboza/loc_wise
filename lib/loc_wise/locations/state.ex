defmodule LocWise.Locations.State do
  use Ecto.Schema
  import Ecto.Changeset

  schema "states" do
    field :acronym, :string
    field :name, :string
    field :region, Ecto.Enum, values: [:north, :northeast, :southeast, :south, :midwest]

    timestamps()
  end

  @doc false
  def changeset(state, attrs) do
    state
    |> cast(attrs, [:name, :acronym, :region])
    |> validate_required([:name, :acronym, :region])
    |> validate_length(:acronym, is: 2)
  end
end
