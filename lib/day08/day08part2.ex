defmodule Aoc2023.Day08Part2 do
  def run do
    File.read!("lib/day08/input08.txt")
    |> processInput
    |> calculateResult
  end

  defp processInput(file) do
    [instructions | maps] = String.split(file, "\n\n", trim: true)
    instructions = String.split(instructions, "", trim: true)

    initialPositions =
      String.split(hd(maps), "\n", trim: true)
      |> Enum.filter(fn el ->
        String.at(el, 2) === "A"
      end)
      |> Enum.map(fn el ->
        String.slice(el, 0..2)
      end)

    maps =
      String.split(hd(maps), "\n", trim: true)
      |> Enum.map(fn instruction ->
        [key | [left | right]] =
          String.replace(instruction, ["=", "(", ",", ")"], " ")
          |> String.split(" ", trim: true)

        %{key => %{"L" => left, "R" => hd(right)}}
      end)
      |> Enum.reduce(%{}, fn instruction, acc ->
        Map.merge(instruction, acc)
      end)

    [instructions, maps, initialPositions]
  end

  defp calculateResult([instructions, maps, initialPositions]) do
    Enum.map(initialPositions, fn position ->
      initialSteps = %{steps: 0, position: position, is_finished: false}
      loopInstructions([instructions, maps], initialSteps)
    end)
    |> Enum.reduce(1, fn steps, acc ->
      trunc(leastCommonMultiple(steps, acc))
    end)
  end

  defguardp isNotAtEnd(_, steps) when steps.is_finished == false
  defguardp isAtEnd(_, steps) when steps.is_finished == true

  defp loopInstructions([instructions, maps], prevSteps) when isNotAtEnd(_, prevSteps) do
    steps =
      Enum.reduce(instructions, prevSteps, fn instruction, acc ->
        cond do
          String.at(acc.position, 2) == "Z" ->
            %{steps: acc.steps, position: acc.position, is_finished: true}

          true ->
            position = maps[acc.position][instruction]
            %{steps: acc.steps + 1, position: position, is_finished: false}
        end
      end)

    loopInstructions([instructions, maps], steps)
  end

  defp loopInstructions(_, prevSteps) when isAtEnd(_, prevSteps) do
    prevSteps.steps
  end

  defp leastCommonMultiple(a, b) do
    a / Integer.gcd(a, b) * b
  end
end
