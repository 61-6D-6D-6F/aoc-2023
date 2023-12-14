defmodule Aoc2023.Day12Part1 do
  def run do
    # ----
    # TODO: change brute force method
    # ----
    File.stream!("lib/day12/input12.txt")
    |> processInput
    |> calculateResult()
  end

  defp processInput(file) do
    Enum.map(file, fn line ->
      variantLoop(line)
    end)
  end

  defp calculateResult(allVariants) do
    allVariants
    |> Enum.map(fn variants ->
      {variants, sizes} = variants

      Enum.filter(variants, fn variant ->
        variantSizes =
          String.split(variant, ".", trim: true)
          |> Enum.map(fn loc ->
            String.split(loc, "", trim: true)
            |> Enum.count()
          end)

        sizes =
          List.first(sizes)
          |> String.split(",", trim: true)
          |> Enum.map(fn num ->
            String.to_integer(num)
          end)

        variantSizes == sizes
      end)
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  defp variantLoop(line) when is_bitstring(line) do
    [locs | sizes] = String.split(line, [" ", "\n"], trim: true)
    variantLoop([locs], sizes, :not_done)
  end

  defp variantLoop(variants, sizes, :not_done) do
    generatedVariants =
      Enum.map(variants, fn locs ->
        [replaceFirstOccurance(locs, "#"), replaceFirstOccurance(locs, ".")]
      end)
      |> List.flatten()

    firstGeneratedVariant = List.first(generatedVariants)
    isDone = isDone(firstGeneratedVariant)

    variantLoop(generatedVariants, sizes, isDone)
  end

  defp variantLoop(variants, sizes, :done) do
    {variants, sizes}
  end

  defp replaceFirstOccurance(locs, replacement) do
    locs = String.split(locs, "", trim: true)

    {newLocs, _} =
      Enum.reduce(0..(length(locs) - 1), {locs, :not_done}, fn i, {locs, isDone} ->
        loc = Enum.at(locs, i)

        cond do
          loc == "?" and isDone == :not_done ->
            newLocs =
              List.replace_at(locs, i, replacement)

            {newLocs, :done}

          true ->
            {locs, isDone}
        end
      end)

    newLocs |> Enum.join()
  end

  defp isDone(locs) do
    (String.replace(locs, "?", " ") == locs and :done) || :not_done
  end
end
