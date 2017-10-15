defmodule Abracadabra.Mob do
  use Ecto.Schema

  schema "mobs" do
    field :name, :string
    field :type, :string
    field :min_lvl, :integer
    field :max_lvl, :integer
    field :last_updated, :naive_datetime
    timestamps()
  end
end
