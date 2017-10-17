defmodule Abracadabra.Mob do
  use Ecto.Schema

  schema "actors" do
    field :name, :string
    field :type, :string
    field :min_lvl, :integer
    field :max_lvl, :integer
    field :attack_type, :string
    field :attack_speed, :float
    field :loot_ids, {:array, :integer}
    field :zone_ids, {:array, :integer}
    field :quest_ids, {:array, :integer}
    field :agro_range, :integer
    field :agro_chance, :string
    field :good_faction_ids, {:array, :integer}
    field :bad_faction_ids, {:array, :integer}
    field :speed, :integer
    field :last_updated, :naive_datetime
    timestamps()
  end
end
