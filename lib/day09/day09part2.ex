defmodule Aoc2023.Day09Part2 do
  def run do
    File.stream!("lib/day09/input09.txt")
    |> processInput
    |> calculateResult
  end

  defp processInput(input) do
    Enum.map(input, fn line ->
      line = String.split(line, [" ", "\n"], trim: true)
      nums = Enum.map(line, fn num -> String.to_integer(num) end)
      %{diffs: nums, carried_sum: [List.first(nums)], is_found: false}
    end)
  end

  defp calculateResult(sequences) do
    Enum.map(sequences, fn seq ->
      difference(seq)
    end)
    |> Enum.map(fn nums ->
      Enum.reduce(nums, fn num, acc ->
        -acc + num
      end)
    end)
    |> Enum.sum()
  end

  defguardp isNextNotFound(seq) when seq.is_found == false
  defguardp isNextFound(seq) when seq.is_found == true

  defp difference(seq) when isNextNotFound(seq) do
    diffs =
      Enum.chunk_every(seq.diffs, 2, 1, :discard)
      |> Enum.map(fn [a, b] -> b - a end)

    newSeq = sequence(seq, diffs)

    difference(newSeq)
  end

  defp difference(seq) when isNextFound(seq) do
    seq.result
  end

  defp sequence(seq, diffs) do
    isDiffAllSame =
      Enum.reduce(diffs, true, fn diff, acc ->
        List.first(diffs) == diff and acc
      end)

    cond do
      isDiffAllSame ->
        %{result: [List.first(diffs) | seq.carried_sum], is_found: true}

      true ->
        %{diffs: diffs, carried_sum: [List.first(diffs) | seq.carried_sum], is_found: false}
    end
  end
end
