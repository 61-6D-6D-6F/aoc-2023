defmodule Aoc2023.Day03Part1 do
  def run do
    {:ok, file} = File.read("lib/day03/input03.txt")
    transformedData = transformData(file)
    symbolPositions = getSymbolPositions(transformedData)

    collectResult(transformedData, symbolPositions)
  end

  defp transformData(file) do
    splitToLines(file)
    |> indexData
    |> chunkData
    |> removeDots
    |> flattenData
  end

  defp getSymbolPositions(data) do
    filterSymbols(data)
    |> flattenPositionsWithRange
    |> Enum.chunk_every(2)
  end

  defp collectResult(data, symbolPositions) do
    filterNumbers(data)
    |> chunkPositions
    |> flagNumbers(symbolPositions)
    |> addNumbers
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

  defp removeDots(data) do
    Enum.filter(data, fn element -> Enum.at(Enum.at(element, 0), 0) !== "." end)
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

  defp filterSymbols(data) do
    Enum.filter(data, fn [head | _] ->
      !String.starts_with?(head, ["1", "2", "3", "4", "5", "6", "7", "8", "9"])
    end)
  end

  defp flattenPositionsWithRange(data) do
    Enum.reduce(data, [], fn [_, rowId, lineId], acc ->
      [
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
        | acc
      ]
    end)
  end

  defp filterNumbers(data) do
    Enum.filter(data, fn [head | _] ->
      String.starts_with?(head, ["1", "2", "3", "4", "5", "6", "7", "8", "9"])
    end)
  end

  defp chunkPositions(data) do
    Enum.map(data, fn [head | tail] -> [head | Enum.chunk_every(tail, 2)] end)
  end

  defp flagNumbers(data, symbolPositions) do
    Enum.map(data, fn [head | tail] ->
      [
        head
        | Enum.reduce(tail, false, fn numPos, acc ->
            Enum.find_value(symbolPositions, false, fn symbPos -> symbPos === numPos end) or
              acc
          end)
      ]
    end)
  end

  defp addNumbers(data) do
    Enum.reduce(data, 0, fn [head | tail], acc ->
      cond do
        tail === false ->
          acc

        true ->
          {num, _} = Integer.parse(head, 10)
          num + acc
      end
    end)
  end
end
