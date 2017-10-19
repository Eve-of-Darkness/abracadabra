defmodule Abracadabra.Actor do
  use Ecto.Schema
  import Ecto.Changeset

  alias Abracadabra.{Actor}

  @permitted_fields [
    :name,
    :type,
    :min_lvl,
    :max_lvl,
    :attack_type,
    :attack_speed,
    :loot_ids,
    :zone_ids,
    :quest_ids,
    :agro_range,
    :agro_chance,
    :good_faction_ids,
    :bad_faction_ids,
    :speed,
    :last_updated,
    :source_type,
    :source_id
  ]

  @required_fields [
    :name,
    :source_type,
    :source_id
  ]

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
    field :source_type, :string
    field :source_id, :string
    timestamps()
  end

  def changeset(%Actor{}=actor \\ %Actor{}, params) do
    actor
    |> cast(params, @permitted_fields)
    |> validate_required(@required_fields)
  end
end
