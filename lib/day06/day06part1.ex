defmodule Aoc2023.Day06Part1 do
  def run do
    File.read!("lib/day06/input06.txt")
    |> processInput
    |> calculateResult
  end

  defp processInput(file) do
    [times | dists] = String.split(file, "\n", trim: true)
    times = tl(String.split(times, " ", trim: true))
    dists = tl(String.split(hd(dists), " ", trim: true))
    endRange = length(times) - 1

    Enum.map(0..endRange, fn i ->
      {time, _} = Integer.parse(Enum.at(times, i), 10)
      {dist, _} = Integer.parse(Enum.at(dists, i), 10)
      [time, dist]
    end)
  end

  defp calculateResult(data) do
    Enum.reduce(data, 1, fn [time, dist], acc ->
      endRange = round((time - 1) / 2)

      numOfWins =
        Enum.reduce(1..endRange, 0, fn i, acc ->
          pressing = i
          travelling = time - i

          cond do
            dist < pressing * travelling ->
              max(travelling - pressing + 1, acc)

            true ->
              acc
          end
        end)

      numOfWins * acc
    end)
  end
end
