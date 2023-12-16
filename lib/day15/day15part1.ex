defmodule Aoc2023.Day15Part1 do
  def run() do
    File.read!("lib/day15/input15.txt")
    |> processInput()
  end

  def processInput(input) do
    input
    |> String.replace("\n", "")
    |> String.split(",", trim: true)
    |> Enum.map(fn str -> hashStr(str, 0) end)
    |> Enum.sum()
  end

  def hashStr(str, startNum) do
    str
    |> String.split("", trim: true)
    |> Enum.reduce(startNum, fn ch, acc ->
      rem((acc + List.first(String.to_charlist(ch))) * 17, 256)
    end)
  end
end

