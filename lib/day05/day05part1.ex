defmodule Aoc2023.Day05Part1 do
  def run do
    File.read!("lib/day05/input05.txt")
    |> processInput
    |> calculateResult
  end

  defp processInput(file) do
    [seeds | almanac] = String.split(file, "\n\n", trim: true)
    seedList = getSeedList(seeds)
    almanacList = getAlmanacList(almanac)
    [seedList, almanacList]
  end

  defp calculateResult([seeds, almanac]) do
    Enum.reduce(seeds, fn seed, acc ->
      {location, _} =
        Enum.reduce(almanac, seed, fn mapType, {num, _} ->
          convert({num, :not_found}, mapType)
        end)

      min(location, acc)
    end)
  end

  defp getSeedList(seeds) do
    [_ | seeds] = String.split(seeds, " ", trim: true)

    Enum.map(seeds, fn seed ->
      {num, _} = Integer.parse(seed, 10)
      {num, :not_found}
    end)
  end

  defp getAlmanacList(almanac) do
    Enum.map(almanac, fn mapType ->
      [_ | maps] = String.split(mapType, "\n", trim: true)

      Enum.map(maps, fn mapLine ->
        String.split(mapLine, " ", trim: true)
        |> Enum.map(fn mapRecord ->
          {num, _} = Integer.parse(mapRecord, 10)
          num
        end)
      end)
    end)
  end

  defp convert(sourceNum, map) do
    Enum.reduce(map, sourceNum, fn [dest, source, range], {destNum, isFound} ->
      cond do
        isFound == :found ->
          {destNum, :found}

        source <= destNum and destNum < source + range ->
          delta = dest - source
          {destNum + delta, :found}

        true ->
          {destNum, :not_found}
      end
    end)
  end
end
