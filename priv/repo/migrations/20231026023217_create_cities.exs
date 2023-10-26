defmodule LocWise.Repo.Migrations.CreateCities do
  use Ecto.Migration

  def change do
    create table(:cities) do
      add :name, :string
      add :state, references(:states, on_delete: :nothing)

      timestamps()
    end

    create index(:cities, [:state])
  end
end
