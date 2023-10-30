defmodule LocWise.Repo.Migrations.AddCodeOnStates do
  use Ecto.Migration

  def change do
    alter table(:states) do
      add :code, :integer
    end
  end
end
