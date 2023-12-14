defmodule Aoc2023.Day02Part1 do
  def run do
    File.stream!("lib/day02/input02.txt")
    |> Enum.reduce(0, &processLine/2)
  end

  defp processLine(line, acc) do
    gameLine =
      String.replace(line, ~r{[\r\n]}, "")
      |> String.split(":", trim: true)

    {gameId, _} =
      List.first(gameLine)
      |> String.replace("Game ", "")
      |> Integer.parse(10)

    isGamePossible =
      List.last(gameLine)
      |> String.split([",", ";"], trim: true)
      |> Enum.reduce(true, fn cube, acc ->
        cubeInfo = String.split(cube, " ", trim: true)
        {num, _} = Integer.parse(List.first(cubeInfo), 10)
        color = List.last(cubeInfo)

        isPossible =
          (num <= 12 and color == "red") or
            (num <= 13 and color == "green") or
            (num <= 14 and color == "blue")

        isPossible and acc
      end)

    cond do
      isGamePossible -> gameId + acc
      !isGamePossible -> acc
    end
  end
end
