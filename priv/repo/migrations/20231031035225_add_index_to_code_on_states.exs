defmodule LocWise.Repo.Migrations.AddIndexToCodeOnStates do
  use Ecto.Migration

  def change do
    create unique_index(:states, :code)
  end
end
