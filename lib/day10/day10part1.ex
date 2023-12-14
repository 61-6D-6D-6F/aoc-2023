defmodule Aoc2023.Day10Part1 do
  def run do
    File.read!("lib/day10/input10.txt")
    |> processInput
    |> calculateResult
  end

  defp processInput(file) do
    tiles =
      String.replace(file, [" ", "\n"], "")
      |> String.split("", trim: true)

    Map.new(1..length(tiles), fn i ->
      convertTile(tiles, i)
    end)
  end

  defp calculateResult(tiles) do
    numOfNotWalked =
      Map.keys(walk(tiles))
      |> Enum.count()

    trunc((tiles.start.size ** 2 - (numOfNotWalked - 1)) / 2)
  end

  defp convertTile(tiles, ind) do
    tile = ind - 1

    size = trunc(length(tiles) ** 0.5)

    case Enum.at(tiles, ind) do
      "S" -> {:start, %{pos: tile, size: size}}
      "|" -> {tile, %{(tile - size) => tile + size, (tile + size) => tile - size}}
      "-" -> {tile, %{(tile - 1) => tile + 1, (tile + 1) => tile - 1}}
      "L" -> {tile, %{(tile - size) => tile + 1, (tile + 1) => tile - size}}
      "J" -> {tile, %{(tile - size) => tile - 1, (tile - 1) => tile - size}}
      "7" -> {tile, %{(tile + size) => tile - 1, (tile - 1) => tile + size}}
      "F" -> {tile, %{(tile + size) => tile + 1, (tile + 1) => tile + size}}
      _ -> {tile, :ground}
    end
  end

  defp walk(tileMap) do
    startPos = tileMap.start.pos

    first =
      tileMap
      |> Enum.filter(fn
        {:start, _} -> false
        {_, :ground} -> false
        {_, next} -> next[startPos] !== nil
      end)
      |> List.first()

    {pos, nextMap} = first
    nextPos = nextMap[startPos]

    tileMap = Map.drop(tileMap, [pos])

    walk(tileMap, %{last: pos, next: nextPos, is_end: false})
  end

  defp walk(tileMap, step) when step.is_end == false do
    [tileMap, step] = newStep(tileMap, step)
    walk(tileMap, step)
  end

  defp walk(_, step) when step.is_end == true do
    step.not_walked_map
  end

  defp newStep(tileMap, step) do
    lastPos = step.last
    pos = step.next

    nextPos = tileMap[pos][lastPos]

    tileMap = Map.drop(tileMap, [pos])

    case nextPos do
      nil -> [tileMap, %{not_walked_map: tileMap, is_end: true}]
      _ -> [tileMap, %{last: pos, next: nextPos, is_end: false}]
    end
  end
end
