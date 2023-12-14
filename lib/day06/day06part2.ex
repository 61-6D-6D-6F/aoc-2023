defmodule Aoc2023.Day06Part2 do
  def run do
    File.read!("lib/day06/input06.txt")
    |> processInput
    |> calculateResult
  end

  defp processInput(file) do
    [time | dist] = String.split(file, "\n", trim: true)
    time = tl(String.split(time, " ", trim: true))
    dist = tl(String.split(hd(dist), " ", trim: true))
    time = Enum.join(time)
    dist = Enum.join(dist)
    {time, _} = Integer.parse(time, 10)
    {dist, _} = Integer.parse(dist, 10)
    [time, dist]
  end

  defp calculateResult([time, dist]) do
    endRange = round((time - 1) / 2)

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
  end
end
