defmodule Abracadabra.Import.Allakhazam.ActorSource do
  @moduledoc """
  Responsible for providing Actor data that is a available from
  the website: http://camelot.allakhazam.com
  """
  defstruct id: "",
            raw: "",
            raw_table: [],
            attack_type: "",
            attack_speed: "",
            realm: "",
            type: "",
            name: "",
            min_lvl: "",
            max_lvl: "",
            loot_ids: [],
            known_zone_ids: [],
            related_quest_ids: [],
            last_updated: "",
            aggro_range: "",
            aggro_chance: "",
            raises_faction_ids: [],
            lowers_faction_ids: [],
            speed: ""

  @domain "camelot.allakhazam.com"
  @main_div "div#col-main-inner-3"

  def get(id) do
    with {:ok, raw} <- load_raw_from_allakhazam(id),
         actor <- raw
                  |> load_name
                  |> load_raw_table
                  |> match_table_data_to_attributes
    do
      {:ok, actor}
    else
      {:error, err} -> {:error, err}
      err -> {:error, err}
    end
  end

  defp load_raw_table(module) do
    put_in(module.raw_table, table_data(module))
  end

  defp table_data(data) do
    data
    |> find("table table tr td")
    |> Enum.map(&Floki.filter_out(&1, "script"))
    # There is an issue with the data where some tables have broken html
    # which shows up as duplicate rows being stuffed into an emptry row.
    # Since all data is in a single td at this point we'll remove any items
    # which have a row inside them
    |> Enum.map(&Floki.filter_out(&1, "tr"))
  end

  defp load_name(module) do
    put_in(module.name, find(module, "h1") |> text)
  end

  defp find(%{raw: raw}, search) do
    Floki.find(raw, String.trim("#{@main_div} #{search}"))
  end
  defp find(source, selector) do
    Floki.find(source, selector)
  end

  defp text(source), do: Floki.text(source) |> String.trim

  defp load_raw_from_allakhazam(id) do
    case HTTPotion.get("http://#{@domain}/db/search.html?cmob=#{id}") do
      %{status_code: 200, body: body} ->
        {:ok, %__MODULE__{id: id, raw: body}}
      %{status_code: status} ->
        {:error, "Error Fetcching Actor with id #{id} [#{status}]"}
    end
  end

  defp match_table_data_to_attributes(module) do
    Enum.reduce(module.raw_table, module, &set_from_row/2)
  end

  defp set_from_row({_, _, [{"b", _, ["Related Quests:"]} | _]}=html, module) do
    put_in(
      module.related_quest_ids,
      find(html, "ul li a") |> strip_out_href_ids("/quests.html?cquest=")
    )
  end
  defp set_from_row({_, _, [{"b", _, ["Known Loot:"]} | _]}=html, module) do
    put_in(
      module.loot_ids,
      find(html, "ul#loots li a") |> strip_out_href_ids("/item.html?citem=")
    )
  end
  defp set_from_row({_, _, [{"b", _, ["Raises Faction with"]} | _]}=html, module) do
    put_in(
      module.raises_faction_ids,
      find(html, "a") |> strip_out_href_ids("faction.html?cfaction=")
    )
  end
  defp set_from_row({_, _, [{"b", _, ["Lowers Faction with"]} | _]}=html, module) do
    put_in(
      module.lowers_faction_ids,
      find(html, "a") |> strip_out_href_ids("faction.html?cfaction=")
    )
  end
  defp set_from_row({_, _, [{"b", _, ["Goods for Sale:"]} | _]}=html, module) do
    put_in(
      module.loot_ids,
      find(html, "li a") |> strip_out_href_ids("/item.html?citem=")
    )
  end
  defp set_from_row({_, _, [{"b", _, ["Known Habitats"]} | _]}=html, module) do
    put_in(
      module.known_zone_ids,
      find(html, "a") |> strip_out_href_ids("/zones.html?czone=")
    )
  end
  defp set_from_row({_, _, [{"b", _, ["Last Updated:"]}, {"small", _, [date_time]}]}, module) do
    put_in(module.last_updated, String.trim(date_time))
  end
  defp set_from_row({_, _, [{"b", _, ["Realm: "]}, {"span", _, [realm]}]}, module) do
    put_in(module.realm, realm)
  end
  defp set_from_row({_, _, [{"b", _, ["Type: "]}| tags]}, module) do
    put_in(module.type, text(tags))
  end
  defp set_from_row({_, _, [{"b", [], ["Aggro Chance:"]}, chance]}, module) do
    put_in(module.aggro_chance, String.trim(chance))
  end
  defp set_from_row({_, _, [{"b", [], ["Attack Speed:"]}, speed]}, module) do
    put_in(module.attack_speed, String.trim(speed))
  end
  defp set_from_row({_, _, [{"b", [], ["Speed:"]}, speed]}, module) do
    put_in(module.speed, String.trim(speed))
  end
  defp set_from_row({_, _, [{"b", [], ["Aggro Range:"]}, range]}, module) do
    put_in(module.aggro_range, String.trim(range))
  end
  defp set_from_row({_, _, [{"b", [], ["Attack Type:"]}, type]}, module) do
    put_in(module.attack_type, String.trim(type))
  end
  defp set_from_row({_, _, [{"b", [], ["Maximum Level"]}, ": "<>lvl]}, module) do
    put_in(module.max_lvl, lvl)
  end
  defp set_from_row({_, _, [{"b", [], ["Minimum Level"]}, ": "<>lvl]}, module) do
    put_in(module.min_lvl, lvl)
  end
  defp set_from_row(_, module), do: module

  defp strip_out_href_ids(html, strip_string) do
    html
    |> Enum.map(&Floki.attribute(&1, "href"))
    |> Enum.map(&List.first/1)
    |> Enum.map(&String.replace(&1, strip_string, ""))
  end
end
