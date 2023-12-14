defmodule Aoc2023.Day04Part1 do
  def run do
    File.stream!("lib/day04/input04.txt")
    |> Enum.reduce(0, &processLine/2)
  end

  defp processLine(line, acc) do
    line = String.replace(line, ~r{[\r\n]}, "")
    [_, winners, numbers] = String.split(line, [":", "|"], trim: true)
    winners = String.split(winners, " ", trim: true)
    numbers = String.split(numbers, " ", trim: true)

    numOfWins =
      Enum.reduce(winners, 0, fn wNum, acc ->
        isWinner = Enum.find(numbers, 0, fn num -> wNum == num end)

        case isWinner do
          0 -> 0 + acc
          _ -> 1 + acc
        end
      end)

    case numOfWins do
      0 -> acc
      _ -> Integer.pow(2, numOfWins - 1) + acc
    end
  end
end
