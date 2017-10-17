defmodule Abracadabra.Repo.Migrations.AddMobs do
  use Ecto.Migration

  def change do
    create table(:actors) do
      add :name, :string
      add :type, :string
      add :min_lvl, :integer
      add :max_lvl, :integer
      add :last_updated, :naive_datetime
      timestamps()
    end
  end
end
