defmodule Abracadabra.Import.Allakhazam.ActorParams do
  alias Abracadabra.Import.Allakhazam.ActorSource

  @direct_keys ~w(attack_type attack_speed realm type name
                  min_lvl max_lvl loot_ids known_zone_ids
                  related_quest_ids last_updated agro_range
                  aggro_chance related_quest_ids lowers_faction_ids
                  speed)a

  def as_params(%ActorSource{}=actor) do
    actor
    |> Map.take(@direct_keys)
    |> Map.merge(%{source_type: "allakhazam", source_id: "#{actor.id}"})
    |> parse_last_updated
  end

  defp parse_last_updated(%{last_updated: ""}=params), do: params
  defp parse_last_updated(%{last_updated: nil}=params), do: params
  defp parse_last_updated(%{last_updated: datestr}=params) do
    case Timex.parse(datestr, "{ANSIC}") do
      {:ok, date} -> %{ params | last_updated: date }
      {:error, _} -> params
    end
  end
end
