defmodule LocWise.Locations.City do
  use Ecto.Schema
  import Ecto.Changeset
  alias LocWise.Locations.State

  schema "cities" do
    field :name, :string
    belongs_to :state, State

    timestamps()
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:name, :state_id])
    |> validate_required([:name, :state_id])
    |> foreign_key_constraint(:state_id)
  end
end
