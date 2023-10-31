defmodule LocWise.Repo.Migrations.ModifyCodeTypeToString do
  use Ecto.Migration

  def change do
    alter table(:cities) do
      modify :code, :string, from: :integer
    end

    alter table(:states) do
      modify :code, :string, from: :integer
    end
  end
end
