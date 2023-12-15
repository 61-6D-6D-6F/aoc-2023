defmodule Aoc2023.Day14Part1 do
  def run() do
    File.read!("lib/day14/input14.txt")
    |> processInput()
  end

  defp processInput(file) do
    rows = String.split(file, "\n", trim: true)
    size = Enum.count(rows)

    transposed = transpose(file, size)

    Enum.map(0..(size - 1), fn i ->
      Enum.filter(transposed, fn {symbol, {_, x}} ->
        x == i and symbol
      end)
      |> Enum.reduce({0, size}, fn {symbol, {y, _}}, {total, load} ->
        cond do
          symbol == "#" ->
            {total, size - (y + 1)}

          symbol == "." ->
            {total, load}

          true ->
            {total + load, load - 1}
        end
      end)
    end)
    |> Enum.reduce(0, fn {total, _}, acc ->
      total + acc
    end)
  end

  defp transpose(file, size) do
    String.replace(file, "\n", "")
    |> String.split("", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {symbol, pos} ->
      row = Integer.floor_div(pos, size)
      column = rem(pos, size)

      {symbol, {row, column}}
    end)
  end
end
