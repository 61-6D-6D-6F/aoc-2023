defmodule Aoc2023.Day08Part1 do
  def run do
    File.read!("lib/day08/input08.txt")
    |> processInput
    |> calculateResult
  end

  defp processInput(file) do
    [instructions | maps] = String.split(file, "\n\n", trim: true)
    instructions = String.split(instructions, "", trim: true)

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

    [instructions, maps]
  end

  defp calculateResult(data) do
    initialSteps = %{steps: 0, position: "AAA"}
    loopInstructions(data, initialSteps)
  end

  defguardp isNotAtEnd(_, steps) when steps.position !== "ZZZ"
  defguardp isAtEnd(_, steps) when steps.position === "ZZZ"

  defp loopInstructions([instructions, maps], prevSteps) when isNotAtEnd(_, prevSteps) do
    steps =
      Enum.reduce(instructions, prevSteps, fn instruction, acc ->
        case acc.position do
          "ZZZ" ->
            acc

          _ ->
            position = maps[acc.position][instruction]
            %{steps: acc.steps + 1, position: position}
        end
      end)

    loopInstructions([instructions, maps], steps)
  end

  defp loopInstructions(_, prevSteps) when isAtEnd(_, prevSteps) do
    prevSteps.steps
  end
end
