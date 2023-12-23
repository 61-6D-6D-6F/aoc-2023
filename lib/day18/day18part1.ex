# https://en.wikipedia.org/wiki/Shoelace_formula
# https://en.wikipedia.org/wiki/Pick%27s_theorem
defmodule Aoc2023.Day18Part1 do
  def run() do
    File.stream!("lib/day18/input18.txt")
    |> processInput()
    |> calculateResult()
  end

  defp processInput(file) do
    dirs = %{"R" => {0, 1}, "L" => {0, -1}, "U" => {-1, 0}, "D" => {1, 0}}

    file
    |> Enum.reduce({[[0, 0]], 0, [0, 0]}, fn line, {accList, accBoundaries, [accY, accX]} ->
      [dir, unit, _] = String.split(line, " ", trim: true)
      unit = String.to_integer(unit)

      {dirY, dirX} = dirs[dir]

      newPoint = [accY + dirY * unit, accX + dirX * unit]
      newAccList = accList ++ [newPoint]
      newBoundaries = accBoundaries + unit

      {newAccList, newBoundaries, newPoint}
    end)
  end

  defp calculateResult({points, boundaries, _}) do
    area =
      Enum.map(0..(length(points) - 1), fn i ->
        Enum.at(Enum.at(points, i), 0) *
          (Enum.at(Enum.at(points, i - 1), 1) -
             Enum.at(Enum.at(points, rem(i + 1, length(points))), 1))
      end)
      |> Enum.sum()
      |> div(2)

    inner = trunc(area - boundaries / 2 + 1)

    inner + boundaries
  end
end
