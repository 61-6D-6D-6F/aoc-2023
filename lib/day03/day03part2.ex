defmodule Aoc2023.Day03Part2 do
  def run do
    file = File.read!("lib/day03/input03.txt")
    transformedData = transformData(file)
    starPositions = getStarPositions(transformedData)

    collectResult(transformedData, starPositions)
  end

  defp transformData(file) do
    splitToLines(file)
    |> indexData
    |> chunkData
    |> removeUnwanted
    |> flattenData
    |> addUniqueId
  end

  defp getStarPositions(data) do
    filterStars(data)
    |> addRangeToPositions
    |> chunkPositions
  end

  defp collectResult(data, starPositions) do
    numberList = filterNumbers(data)
    numberPositions = chunkNumberPositions(numberList)

    assignNumbersToStars(numberPositions, starPositions)
    |> countAll
  end

  defp splitToLines(data) do
    String.split(data, ~r{[\r\n]}, trim: true)
  end

  defp indexData(data) do
    Enum.with_index(data, fn row, rowId -> [row, rowId] end)
    |> Enum.flat_map(fn [row, rowId] ->
      String.split(row, "", trim: true)
      |> Enum.with_index(fn char, lineId -> [char, rowId, lineId] end)
    end)
  end

  defp chunkData(data) do
    Enum.chunk_by(data, fn element ->
      [char, _, _] = element
      parsedChar = Integer.parse(char, 10)

      cond do
        parsedChar !== :error -> :number
        char == "." -> :dot
        true -> :symbol
      end
    end)
  end

  defp removeUnwanted(data) do
    Enum.filter(data, fn element ->
      Enum.at(Enum.at(element, 0), 0) == "*" or
        Enum.at(Enum.at(element, 0), 0) == "1" or
        Enum.at(Enum.at(element, 0), 0) == "2" or
        Enum.at(Enum.at(element, 0), 0) == "3" or
        Enum.at(Enum.at(element, 0), 0) == "4" or
        Enum.at(Enum.at(element, 0), 0) == "5" or
        Enum.at(Enum.at(element, 0), 0) == "6" or
        Enum.at(Enum.at(element, 0), 0) == "7" or
        Enum.at(Enum.at(element, 0), 0) == "8" or
        Enum.at(Enum.at(element, 0), 0) == "9"
    end)
  end

  defp flattenData(data) do
    Enum.map(data, fn element ->
      Enum.reduce(element, [], fn [num, rowId, lineId], acc ->
        case acc do
          [] ->
            [num, rowId, lineId]

          _ ->
            [head | tail] = acc
            [head <> num, rowId, lineId | tail]
        end
      end)
    end)
  end

  defp addUniqueId(data) do
    Enum.map(data, fn [head | tail] ->
      id = System.unique_integer([:positive, :monotonic])
      [head <> "-" <> Integer.to_string(id) | tail]
    end)
  end

  defp filterStars(data) do
    Enum.filter(data, fn [head | _] ->
      String.starts_with?(head, "*")
    end)
  end

  defp addRangeToPositions(data) do
    Enum.map(data, fn [symbol, rowId, lineId] ->
      [
        symbol,
        rowId + 1,
        lineId - 1,
        rowId + 1,
        lineId,
        rowId + 1,
        lineId + 1,
        rowId,
        lineId - 1,
        rowId,
        lineId,
        rowId,
        lineId + 1,
        rowId - 1,
        lineId - 1,
        rowId - 1,
        lineId,
        rowId - 1,
        lineId + 1
      ]
    end)
  end

  defp chunkPositions(data) do
    Enum.map(data, fn [head | tail] -> [head | Enum.chunk_every(tail, 2)] end)
  end

  defp filterNumbers(data) do
    Enum.filter(data, fn [head | _] ->
      String.starts_with?(head, ["1", "2", "3", "4", "5", "6", "7", "8", "9"])
    end)
  end

  defp chunkNumberPositions(data) do
    chunkPositions(data)
    |> Enum.map(fn [head | tail] ->
      Enum.map(tail, fn pos -> [head | pos] end)
    end)
    |> List.flatten()
    |> Enum.chunk_every(3)
  end

  defp assignNumbersToStars(numbers, stars) do
    Enum.map(stars, fn [_ | tail] ->
      Enum.map(tail, fn starPos ->
        Enum.find(numbers, 0, fn [_, rowId, lineId] ->
          [rowId, lineId] === starPos
        end)
      end)
    end)
  end

  defp countAll(stars) do
    Enum.map(stars, fn item ->
      List.flatten(item)
      |> Enum.filter(fn item -> is_binary(item) end)
      |> Enum.uniq()
    end)
    |> Enum.filter(fn item -> 2 == length(item) end)
    |> Enum.map(fn item ->
      Enum.reduce(item, 1, fn item, acc ->
        [numStr, _] = String.split(item, "-", trim: true)
        {num, _} = Integer.parse(numStr, 10)
        num * acc
      end)
    end)
    |> Enum.reduce(0, fn num, acc ->
      num + acc
    end)
  end
end
