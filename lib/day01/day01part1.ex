defmodule Aoc2023.Day01Part1 do
  def run do
    File.stream!("lib/day01/input01.txt")
    |> Enum.reduce(0, &processLine/2)
  end

  defp processLine(line, acc) do
    listOfNumbers =
      String.replace(line, ~r{[a-zA-Z\r\n]}, "")
      |> String.split("", trim: true)

    first = List.first(listOfNumbers)
    last = List.last(listOfNumbers)

    {number, _} =
      (first <> last)
      |> Integer.parse(10)

    number + acc
  end
end
