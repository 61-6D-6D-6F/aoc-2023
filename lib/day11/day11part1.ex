defmodule Aoc2023.Day11Part1 do
  def run do
    File.read!("lib/day11/input11.txt")
    |> processInput()
    |> calculateResult()
  end

  defp processInput(file) do
    size =
      String.split(file, "\n", trim: true)
      |> Enum.count()

    galaxies =
      String.replace(file, "\n", "")
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce([], fn
        {"#", galaxy}, acc ->
          row = Integer.floor_div(galaxy, size)
          column = rem(galaxy, size)

          [{row, column} | acc]

        _, acc ->
          acc
      end)

    {galaxies, size}
  end

  defp calculateResult({galaxies, size}) do
    expandedGalaxies = expandGalaxies(galaxies, size)

    {_, pairedGalaxies} = pairGalaxies(expandedGalaxies)

    sumOfLength(pairedGalaxies)
  end

  defp expandGalaxies(galaxies, size) do
    galaxyRows =
      Enum.map(galaxies, fn {row, _} -> row end)
      |> Enum.uniq()

    galaxyCols =
      Enum.map(galaxies, fn {_, col} -> col end)
      |> Enum.uniq()

    spaceRows = Enum.to_list(0..(size - 1)) -- galaxyRows
    spaceCols = Enum.to_list(0..(size - 1)) -- galaxyCols

    rowExpandedGalaxies =
      Enum.reduce(1..length(spaceRows), galaxies, fn i, acc ->
        spaceRow = Enum.at(spaceRows, i - 1) + i - 1

        Enum.map(acc, fn {row, col} ->
          # true -> 1, false -> 0
          expansion = (spaceRow < row and 1) || 0
          {row + expansion, col}
        end)
      end)

    Enum.reduce(1..length(spaceCols), rowExpandedGalaxies, fn i, acc ->
      spaceCol = Enum.at(spaceCols, i - 1) + i - 1

      Enum.map(acc, fn {row, col} ->
        # true -> 1, false -> 0
        expansion = (spaceCol < col and 1) || 0
        {row, col + expansion}
      end)
    end)
  end

  defp pairGalaxies(galaxies) do
    Enum.reduce(0..(length(galaxies) - 1), {galaxies, []}, fn _, acc ->
      {galaxiesToPair, pairedGalaxies} = acc

      [galaxyToPair | galaxiesToPairWith] = galaxiesToPair

      newGalaxyPairs =
        Enum.map(galaxiesToPairWith, fn galaxy ->
          [galaxyToPair, galaxy]
        end)

      {galaxiesToPairWith, newGalaxyPairs ++ pairedGalaxies}
    end)
  end

  defp sumOfLength(pairs) do
    Enum.map(pairs, fn pair ->
      {x1, y1} = List.first(pair)
      {x2, y2} = List.last(pair)
      abs(x1 - x2) + abs(y1 - y2)
    end)
    |> Enum.sum()
  end
end
