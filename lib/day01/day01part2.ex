defmodule Aoc2023.Day01Part2 do
  def run do
    File.stream!("lib/day01/input01.txt")
    |> Enum.reduce(0, &processLine/2)
  end

  defp processLine(line, acc) do
    to_replace = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

    listForFirstNumber =
      String.replace(line, to_replace, fn
        "one" -> "1"
        "two" -> "2"
        "three" -> "3"
        "four" -> "4"
        "five" -> "5"
        "six" -> "6"
        "seven" -> "7"
        "eight" -> "8"
        "nine" -> "9"
      end)
      |> String.replace(~r{[a-zA-Z\r\n]}, "")
      |> String.split("", trim: true)

    to_replaceReversed = ["eno", "owt", "eerht", "ruof", "evif", "xis", "neves", "thgie", "enin"]

    listForLastNumber =
      String.reverse(line)
      |> String.replace(to_replaceReversed, fn
        "eno" -> "1"
        "owt" -> "2"
        "eerht" -> "3"
        "ruof" -> "4"
        "evif" -> "5"
        "xis" -> "6"
        "neves" -> "7"
        "thgie" -> "8"
        "enin" -> "9"
      end)
      |> String.reverse()
      |> String.replace(~r{[a-zA-Z\r\n]}, "")
      |> String.split("", trim: true)

    first = List.first(listForFirstNumber)
    last = List.last(listForLastNumber)

    {number, _} =
      (first <> last)
      |> Integer.parse(10)

    number + acc
  end
end
