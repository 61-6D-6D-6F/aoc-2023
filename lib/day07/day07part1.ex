defmodule Aoc2023.Day07Part1 do
  def run do
    File.stream!("lib/day07/input07.txt")
    |> processInput
    |> calculateResult
  end

  defp processInput(file) do
    Enum.map(file, fn line ->
      [hand | bid] = String.split(line, ["\n", " "], trim: true)
      {bid, _} = Integer.parse(hd(bid), 10)

      typeFreq =
        String.graphemes(hand)
        |> Enum.frequencies()

      numOfTypes = Enum.count(typeFreq)

      highestNumOfType =
        Enum.reduce(typeFreq, 0, fn {_, num}, acc ->
          max(num, acc)
        end)

      handAsNum = convertHandToNum(hand)

      case [numOfTypes, highestNumOfType] do
        [1, _] ->
          [bid, "7" <> handAsNum]

        [2, 4] ->
          [bid, "6" <> handAsNum]

        [2, 3] ->
          [bid, "5" <> handAsNum]

        [3, 3] ->
          [bid, "4" <> handAsNum]

        [3, 2] ->
          [bid, "3" <> handAsNum]

        [4, _] ->
          [bid, "2" <> handAsNum]

        [_, _] ->
          [bid, "1" <> handAsNum]
      end
    end)
  end

  defp calculateResult(hands) do
    sortedHands = Enum.sort_by(hands, fn [_, rank] -> rank end)
    numOfHands = length(sortedHands) - 1

    winnings =
      Enum.map(0..numOfHands, fn i ->
        [bid | _] = Enum.at(sortedHands, i)
        bid * (i + 1)
      end)

    Enum.sum(winnings)
  end

  def convertHandToNum(hand) do
    String.replace(
      hand,
      ["2", "3", "4", "5", "5", "6", "7", "8", "9", "T", "J", "Q", "K", "A"],
      fn
        "2" -> "01"
        "3" -> "02"
        "4" -> "03"
        "5" -> "04"
        "6" -> "05"
        "7" -> "06"
        "8" -> "07"
        "9" -> "08"
        "T" -> "09"
        "J" -> "10"
        "Q" -> "11"
        "K" -> "12"
        "A" -> "13"
      end
    )
  end
end
