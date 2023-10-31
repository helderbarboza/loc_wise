defmodule LocWise.Locations.City do
  use Ecto.Schema
  import Ecto.Changeset
  alias LocWise.Locations.State

  @derive {
    Flop.Schema,
    filterable: [:name_code],
    sortable: [:name],
    default_limit: 20,
    max_limit: 1000,
    default_order: %{
      order_by: [:name],
      order_directions: [:asc]
    },
    adapter_opts: [
      custom_fields: [
        name_code: [
          filter: {LocWise.FlopFilters, :name_and_code, []},
          ecto_type: :string
        ]
      ]
    ]
  }

  schema "cities" do
    field :name, :string
    field :code, :string
    belongs_to :state, State

    timestamps()
  end

  @doc false
  def changeset(city, attrs) do
    city
    |> cast(attrs, [:name, :state_id, :code])
    |> validate_required([:name, :state_id, :code])
    |> foreign_key_constraint(:state_id)
    |> unique_constraint(:code)
  end
end
