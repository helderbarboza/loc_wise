defmodule LocWise.Repo.Migrations.AddCodeOnCities do
  use Ecto.Migration

  def change do
    alter table(:cities) do
      add :code, :integer
    end
  end
end
