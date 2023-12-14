defmodule Aoc2023.Day02Part2 do
  def run do
    File.stream!("lib/day02/input02.txt")
    |> Enum.reduce(0, &processLine/2)
  end

  defp processLine(line, acc) do
    listOfCubes =
      String.replace(line, ~r{[\r\n]}, "")
      |> String.split(":", trim: true)
      |> List.last()
      |> String.split([",", ";"], trim: true)

    maxRed = filterMaxColor(listOfCubes, "red")
    maxGreen = filterMaxColor(listOfCubes, "green")
    maxBlue = filterMaxColor(listOfCubes, "blue")

    maxRed * maxGreen * maxBlue + acc
  end

  defp filterMaxColor(cubes, cubeColor) do
    maxCube =
      Enum.filter(cubes, fn cube ->
        color =
          String.split(cube, " ", trim: true)
          |> List.last()

        color == cubeColor
      end)
      |> Enum.max_by(fn cube ->
        {num, _} =
          String.split(cube, " ", trim: true)
          |> List.first()
          |> Integer.parse(10)

        num
      end)

    {num, _} =
      String.split(maxCube, " ", trim: true)
      |> List.first()
      |> Integer.parse(10)

    num
  end
end
