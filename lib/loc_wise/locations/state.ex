defmodule LocWise.Locations.State do
  use Ecto.Schema
  import Ecto.Changeset
  alias LocWise.Locations.City

  @derive {
    Flop.Schema,
    filterable: [:name_code],
    sortable: [:name],
    default_limit: 20,
    max_limit: 100,
    default_order: %{
      order_by: [:name],
      order_directions: [:asc]
    },
    adapter_opts: [
      compound_fields: [
        name_code: [:name, :code]
      ]
    ]
  }

  schema "states" do
    field :acronym, :string
    field :name, :string
    field :region, Ecto.Enum, values: [:north, :northeast, :southeast, :south, :midwest]
    field :code, :string
    has_many :cities, City

    timestamps()
  end

  @doc false
  def changeset(state, attrs) do
    state
    |> cast(attrs, [:name, :acronym, :region, :code])
    |> validate_required([:name, :acronym, :region, :code])
    |> validate_length(:acronym, is: 2)
    |> unique_constraint(:code)
  end
end
