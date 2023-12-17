defmodule Aoc2023.Day16Part2 do
  def run() do
    File.read!("lib/day16/input16.txt")
    |> processInput()
    |> calculateResult()
  end

  defp processInput(file) do
    indexTiles(file)
  end

  defp calculateResult({tileMap, size}) do
    positions = startPos(size)

    Enum.map(positions, fn pos ->
      beamStep({tileMap, size}, pos)
      |> Map.keys()
      |> Enum.uniq_by(fn {_, pos} -> pos end)
      |> Enum.count()
    end)
    |> Enum.max()
  end

  defp indexTiles(file) do
    size =
      String.split(file, "\n", trim: true)
      |> Enum.count()

    tileMap =
      String.replace(file, "\n", "")
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Map.new(fn {symbol, index} ->
        row = Integer.floor_div(index, size)
        column = rem(index, size)

        {{row, column}, %{symbol: symbol, energized: false}}
      end)

    {tileMap, size}
  end

  defp startPos(size) do
    Enum.map(0..(size - 1), fn i ->
      [
        {{-1, i}, {0, i}},
        {{i, -1}, {i, 0}},
        {{size, i}, {size - 1, i}},
        {{i, size}, {i, size - 1}}
      ]
    end)
    |> List.flatten()
  end

  defp beamStep(tiles, pos) do
    beamStep(tiles, [pos], %{})
  end

  defp beamStep(_, [], visited) do
    visited
  end

  defp beamStep({tileMap, size}, posList, visitMap) do
    {newPosList, newVisitMap} = newPositions(tileMap, visitMap, size, posList)

    beamStep({tileMap, size}, newPosList, newVisitMap)
  end

  defp newPositions(tileMap, visitMap, size, posList) do
    newVisitMap =
      Enum.reduce(posList, visitMap, fn fromToPos, acc ->
        put_in(acc[fromToPos], true)
      end)

    newPosList =
      Enum.map(posList, fn pos ->
        {_, currentPos} = pos
        currentSymbol = tileMap[currentPos][:symbol]
        nextPos(currentSymbol, pos)
      end)
      |> List.flatten()
      |> Enum.filter(fn pos ->
        {_, {y, x}} = pos

        y < size and x < size and 0 <= y and 0 <= x and !Map.has_key?(newVisitMap, pos)
      end)

    {newPosList, newVisitMap}
  end

  defp nextPos(".", {{prevY, prevX}, {currentY, currentX}}) do
    nextY = currentY + (currentY - prevY)
    nextX = currentX + (currentX - prevX)
    [{{currentY, currentX}, {nextY, nextX}}]
  end

  defp nextPos("\\", {{prevY, prevX}, {currentY, currentX}}) do
    nextY = currentY + (currentX - prevX)
    nextX = currentX + (currentY - prevY)
    [{{currentY, currentX}, {nextY, nextX}}]
  end

  defp nextPos("/", {{prevY, prevX}, {currentY, currentX}}) do
    nextY = currentY - (currentX - prevX)
    nextX = currentX - (currentY - prevY)
    [{{currentY, currentX}, {nextY, nextX}}]
  end

  defp nextPos("|", {{prevY, prevX}, {currentY, currentX}}) when prevX == currentX do
    nextY = currentY + (currentY - prevY)
    [{{currentY, currentX}, {nextY, currentX}}]
  end

  defp nextPos("|", {{_, _}, {currentY, currentX}}) do
    nextYOne = currentY + 1
    nextYTwo = currentY - 1
    [{{currentY, currentX}, {nextYOne, currentX}}, {{currentY, currentX}, {nextYTwo, currentX}}]
  end

  defp nextPos("-", {{prevY, prevX}, {currentY, currentX}}) when prevY == currentY do
    nextX = currentX + (currentX - prevX)
    [{{currentY, currentX}, {currentY, nextX}}]
  end

  defp nextPos("-", {{_, _}, {currentY, currentX}}) do
    nextXOne = currentX + 1
    nextXTwo = currentX - 1
    [{{currentY, currentX}, {currentY, nextXOne}}, {{currentY, currentX}, {currentY, nextXTwo}}]
  end
end
