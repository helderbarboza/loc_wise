defmodule LocWise.Repo.Migrations.AddIndexToCodeOnCities do
  use Ecto.Migration

  def change do
    create unique_index(:cities, :code)
  end
end
