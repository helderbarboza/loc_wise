defmodule LocWise.Repo.Migrations.CreateStates do
  use Ecto.Migration

  def change do
    create table(:states) do
      add :name, :string
      add :acronym, :string
      add :region, :string

      timestamps()
    end
  end
end
