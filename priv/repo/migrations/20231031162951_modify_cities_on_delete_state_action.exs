defmodule LocWise.Repo.Migrations.ModifyCitiesOnDeleteStateAction do
  use Ecto.Migration

  def change do
    alter table(:cities) do
      modify :state_id,
             references(:states, on_delete: :delete_all),
             from: references(:states, on_delete: :nothing)
    end
  end
end
