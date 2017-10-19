defmodule Mix.Tasks.Import.Mobs do
  use Mix.Task
  alias Abracadabra.{Actor, Repo}
  alias Abracadabra.Import.Allakhazam.{ActorSource, ActorParams}

  @shortdoc "Import mobs"

  def run(_) do
    Application.ensure_all_started(:abracadabra)
    IO.write "Attempint to import #{14976} mobs"

    ActorSource.stream
    |> Flow.from_enumerable
    |> Flow.reject(fn x ->
      status = elem(x, 0)

      if status == :error do
        IO.inspect x
        true
      else
        IO.puts "lskdjfd"
        false
      end
    end)
    |> Flow.map(&elem(&1, 1))
    |> Flow.each(fn actor_source ->
      actor_source
      |> ActorParams.as_params
      |> Actor.changeset
      |> Repo.insert
      |> case do
        {:ok, _} -> IO.write "."
        {:error, error} -> IO.inspect error
      end
    end)
    |> Flow.run
  end
end
