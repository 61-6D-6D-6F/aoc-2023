defmodule Aoc2023.Day17Part1 do
  def run() do
    # File.read!("lib/day17/test.txt")
    File.read!("lib/day17/input17.txt")
    |> processInput()
    |> calculateResult()
  end

  defp processInput(file) do
    size =
      String.split(file, "\n", trim: true)
      |> Enum.count()

    map =
      String.replace(file, "\n", "")
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Map.new(fn {heatLoss, index} ->
        heatLoss = String.to_integer(heatLoss)
        row = Integer.floor_div(index, size)
        column = rem(index, size)

        {{row, column}, heatLoss}
      end)

    {map, size}
  end

  defp calculateResult({map, size}) do
    step(map, size, [{0, 0, 0, 0, 0, 0}], MapSet.new())
  end

  defp step(map, size, pQueue, visited) do
    {{heatLoss, y, x, dY, dX, count}, restPQueue} = minFromPQueue(pQueue)
    IO.inspect(heatLoss)

    if x == size - 1 and y == size - 1 do
      heatLoss
    else
      if MapSet.member?(visited, {y, x, dY, dX, count}) do
        step(map, size, restPQueue, visited)
      else
        newVisited = MapSet.put(visited, {y, x, dY, dX, count})

        newPQueue = nextBlock({heatLoss, y, x, dY, dX, count}, map, size, restPQueue)

        step(map, size, newPQueue, newVisited)
      end
    end
  end

  defp minFromPQueue(pQueue) do
    min =
      Enum.reduce(pQueue, fn queue, acc ->
        {heatLoss, _, _, _, _, _} = queue
        {accHeatLoss, _, _, _, _, _} = acc

        cond do
          heatLoss < accHeatLoss -> queue
          true -> acc
        end
      end)

    rest =
      Enum.filter(pQueue, fn item ->
        item !== min
      end)

    {min, rest}
  end

  defp nextBlock({heatLoss, y, x, dY, dX, count}, map, size, pQueue) do
    dirs = [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]

    Enum.reduce(dirs, pQueue, fn {dirY, dirX}, acc ->
      newY = y + dirY
      newX = x + dirX

      cond do
        {dirY, dirX} == {dY, dX} ->
          cond do
            count + 1 === 4 ->
              acc

            true ->
              newY = y + dY
              newX = x + dX

              cond do
                0 <= newY and 0 <= newX and newX < size and newY < size ->
                  [{heatLoss + map[{newY, newX}], newY, newX, dY, dX, count + 1} | acc]

                true ->
                  acc
              end
          end

        {dirY, dirX} == {-dY, -dX} ->
          acc

        true ->
          cond do
            0 <= newY and 0 <= newX and newX < size and newY < size ->
              [{heatLoss + map[{newY, newX}], newY, newX, dirY, dirX, 1} | acc]

            true ->
              acc
          end
      end
    end)
  end
end
