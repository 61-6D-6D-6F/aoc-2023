defmodule Aoc2023.Day15Part2 do
  def run() do
    File.read!("lib/day15/input15.txt")
    |> processInput()
    |> calculateResult()
  end

  def processInput(input) do
    input
    |> String.replace("\n", "")
    |> String.split(",", trim: true)
    |> Enum.map(fn str ->
      instructions = String.split(str, ["=", "-"], trim: true)

      cond do
        length(instructions) == 1 ->
          [:remove] ++ [hashStr(List.first(instructions), 0)] ++ instructions ++ [0]

        true ->
          [:add] ++ [hashStr(List.first(instructions), 0)] ++ instructions
      end
    end)
    |> Enum.with_index()
    |> Enum.map(fn instruction ->
      Tuple.to_list(instruction)
      |> List.flatten()
    end)
  end

  def hashStr(str, startNum) do
    str
    |> String.split("", trim: true)
    |> Enum.reduce(startNum, fn ch, acc ->
      rem((acc + List.first(String.to_charlist(ch))) * 17, 256)
    end)
  end

  def calculateResult(input) do
    boxes =
      Map.new(0..255, fn i ->
        {i, %{}}
      end)

    input
    |> Enum.reduce(boxes, fn [inst, box, key, value, ind], acc ->
      cond do
        inst == :remove ->
          update_in(acc, [box], fn _ -> Map.delete(acc[box], key) end)

        Map.has_key?(acc[box], key) ->
          put_in(acc[box][key][:v], value)

        true ->
          put_in(acc[box][key], %{v: value, i: ind})
      end
    end)
    |> Map.filter(fn {_, lens} ->
      length(Map.values(lens)) !== 0
    end)
    |> Map.to_list()
    |> Enum.map(fn {box, lens} ->
      lens = Map.to_list(lens)

      Enum.map(lens, fn len ->
        {_, len} = len
        [len[:i], box, len[:v]]
      end)
      |> Enum.sort_by(fn len -> hd(len) end)
    end)
    |> Enum.map(fn box ->
      Enum.map(0..(length(box) - 1), fn i ->
        [_ | [boxNum | fLen]] = Enum.at(box, i)
        (boxNum + 1) * (i + 1) * String.to_integer(List.first(fLen))
      end)
    end)
    |> List.flatten()
    |> Enum.sum()
  end
end
