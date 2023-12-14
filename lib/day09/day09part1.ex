defmodule Aoc2023.Day09Part1 do
  def run do
    File.stream!("lib/day09/input09.txt")
    |> processInput
    |> calculateResult
  end

  defp processInput(input) do
    Enum.map(input, fn line ->
      line = String.split(line, [" ", "\n"], trim: true)
      nums = Enum.map(line, fn num -> String.to_integer(num) end)
      %{nums: nums, diffs: nums, carried_sum: List.last(nums), is_found: false}
    end)
  end

  defp calculateResult(sequences) do
    Enum.map(sequences, fn seq ->
      difference(seq, -3)
    end)
    |> Enum.reduce(0, fn seq, acc -> seq + acc end)
  end

  defguardp isNextNotFound(seq, _) when seq.is_found == false
  defguardp isNextFound(seq, _) when seq.is_found == true

  defp difference(seq, indexFromEnd) when isNextNotFound(seq, _) do
    diffs =
      Enum.take(seq.diffs, indexFromEnd)
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)

    newSeq = sequence(seq, diffs)

    difference(newSeq, indexFromEnd - 1)
  end

  defp difference(seq, _) when isNextFound(seq, _) do
    seq.result
  end

  defp sequence(seq, diffs) do
    isDiffAllSame =
      Enum.reduce(diffs, true, fn diff, acc ->
        List.first(diffs) == diff and acc
      end)

    isDiffListReducable = 2 < length(diffs)

    cond do
      isDiffAllSame ->
        %{result: List.last(diffs) + seq.carried_sum, is_found: true}

      isDiffListReducable ->
        %{
          nums: seq.nums,
          diffs: diffs,
          carried_sum: List.last(diffs) + seq.carried_sum,
          is_found: false
        }

      true ->
        %{nums: seq.nums, diffs: seq.nums, carried_sum: List.last(seq.nums), is_found: false}
    end
  end
end
