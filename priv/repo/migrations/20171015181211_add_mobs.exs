defmodule Abracadabra.Repo.Migrations.AddMobs do
  use Ecto.Migration

  def change do
    create table(:actors) do
      add :name, :string
      add :type, :string
      add :min_lvl, :integer
      add :max_lvl, :integer
      add :attack_type, :string
      add :attack_speed, :float
      add :loot_ids, {:array, :integer}
      add :zone_ids, {:array, :integer}
      add :quest_ids, {:array, :integer}
      add :agro_range, :integer
      add :agro_chance, :string
      add :good_faction_ids, {:array, :integer}
      add :bad_faction_ids, {:array, :integer}
      add :speed, :integer
      add :last_updated, :naive_datetime
      add :source_type, :string
      add :source_id, :string
      timestamps()
    end
  end
end
