defmodule Abracadabra.Import.Allakhazam.ActorSourceTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock
  alias Abracadabra.Import.Allakhazam.ActorSource

  setup_all do
    ExVCR.Config.cassette_library_dir("fixture/vcr_cassettes")
    :ok
  end

  describe "Grabbing an NPC Merchant (66661)" do
    setup _ do
      {:ok, npc} = use_cassette "allakhazam-npc-merchant", do: ActorSource.get("6661")
      {:ok, npc: npc}
    end

    test "id", data, do: assert data.npc.id == "6661"
    test "min_lvl", data, do: assert data.npc.min_lvl == "50"
    test "max_lvl", data, do: assert data.npc.max_lvl == "50"
    test "known_zone_ids", data, do: assert data.npc.known_zone_ids == ["1"]
    test "related_quest_ids", data, do: assert data.npc.related_quest_ids == ["527"]
    test "loot_ids", data, do: assert Enum.count(data.npc.loot_ids) == 24
    test "name", data, do: assert data.npc.name == "Brother Salvar"
    test "realm", data, do: assert data.npc.realm == "Albion"
    test "last_updated", data, do: assert data.npc.last_updated == "Wed Dec  7 12:32:22 2005"
    test "type", data, do: assert data.npc.type == "Merchant(Staves)"
    test "other fields remain 'blank'", %{npc: npc} do
      assert npc.attack_type == ""
      assert npc.attack_speed == ""
      assert npc.aggro_chance == ""
      assert npc.aggro_range == ""
      assert npc.speed == ""
      assert npc.raises_faction_ids == []
      assert npc.lowers_faction_ids == []
    end
  end
end
