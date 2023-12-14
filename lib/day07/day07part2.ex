defmodule Aoc2023.Day07Part2 do
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

      [numOfTypes, highestNumOfType] = highestNumOfType(typeFreq)

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

  defp highestNumOfType(typeFreq) do
    numOfTypes = Enum.count(typeFreq)

    highestNumOfType =
      Enum.reduce(typeFreq, 0, fn {card, num}, acc ->
        case card do
          "J" -> acc
          _ -> max(num, acc)
        end
      end)

    case Map.fetch(typeFreq, "J") do
      {_, 5} -> [1, 5]
      {_, numOfJokers} -> [numOfTypes - 1, highestNumOfType + numOfJokers]
      :error -> [numOfTypes, highestNumOfType]
    end
  end

  def convertHandToNum(hand) do
    String.replace(
      hand,
      ["J", "2", "3", "4", "5", "5", "6", "7", "8", "9", "T", "Q", "K", "A"],
      fn
        "J" -> "01"
        "2" -> "02"
        "3" -> "03"
        "4" -> "04"
        "5" -> "05"
        "6" -> "06"
        "7" -> "07"
        "8" -> "08"
        "9" -> "09"
        "T" -> "10"
        "Q" -> "11"
        "K" -> "12"
        "A" -> "13"
      end
    )
  end
end
