defmodule Aoc2023.Day04Part2 do
  def run do
    File.read!("lib/day04/input04.txt")
    |> processInput
    |> addCards
    |> calculateResult
  end

  defp processInput(file) do
    line = String.split(file, "\n", trim: true)
    cards = Enum.with_index(line, fn el, ind -> [el, ind] end)

    Enum.map(cards, fn [card, ind] ->
      card = String.replace(card, ~r{[\r\n]}, "")
      [_, winners, numbers] = String.split(card, [":", "|"], trim: true)
      winners = String.split(winners, " ", trim: true)
      numbers = String.split(numbers, " ", trim: true)

      numOfWins =
        Enum.reduce(winners, 0, fn winner, acc ->
          isWinner = Enum.find(numbers, 0, fn number -> winner == number end)

          case isWinner do
            0 -> 0 + acc
            _ -> 1 + acc
          end
        end)

      [numOfWins, ind, 1]
    end)
  end

  defp addCards(cards) do
    cardsRange = toRange(cards)

    Enum.reduce(cardsRange, cards, fn i, acc ->
      [numOfWins, ind, numOfCards] = Enum.at(acc, i)
      newCardsRange = toRange(numOfWins)

      Enum.reduce(newCardsRange, acc, fn i, acc ->
        nextInd = ind + i

        List.update_at(acc, nextInd, fn [nextNOWs, nextInd, nextNOCs] ->
          [nextNOWs, nextInd, nextNOCs + numOfCards]
        end)
      end)
    end)
  end

  defp calculateResult(cards) do
    Enum.reduce(cards, 0, fn [_, _, numOfCards], acc ->
      numOfCards + acc
    end)
  end

  defp toRange(input) do
    cond do
      input == 0 -> []
      is_list(input) -> Enum.to_list(0..(length(input) - 1))
      true -> Enum.to_list(1..input)
    end
  end
end
