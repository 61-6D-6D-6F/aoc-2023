defmodule Aoc2023.Day19Part1 do
  def run() do
    File.read!("lib/day19/input19.txt")
    |> processInput()
    |> calculateResult()
  end

  defp processInput(file) do
    [map, items] = String.split(file, "\n\n", trim: true)

    map =
      String.split(map, "\n", trim: true)
      |> Map.new(fn row ->
        [key, value] = String.split(row, ["{", "}"], trim: true)
        values = String.split(value, [":", ","], trim: true)
        newValue = valueTree(values)
        {key, newValue}
      end)

    items =
      String.split(items, "\n", trim: true)
      |> Enum.map(fn item ->
        [x, m, a, s] = String.split(item, ["{", ",", "}"], trim: true)
        x = String.to_integer(String.slice(x, 2..-1))
        m = String.to_integer(String.slice(m, 2..-1))
        a = String.to_integer(String.slice(a, 2..-1))
        s = String.to_integer(String.slice(s, 2..-1))
        {x, m, a, s}
      end)

    {map, items}
  end

  defp calculateResult({map, items}) do
    Enum.map(items, fn item ->
      flow(item, map, "in")
    end)
    |> Enum.filter(fn item ->
      item !== :rejected
    end)
    |> Enum.map(fn {x, m, a, s} ->
      x + m + a + s
    end)
    |> Enum.sum()
  end

  defp valueTree(values) do
    [cond | rest] = values
    [ifTrue | restRest] = rest
    ifFalse = chainFalse(restRest)

    {cond, {ifTrue, ifFalse}}
  end

  defp chainFalse(rest) do
    cond do
      length(rest) == 1 ->
        hd(rest)

      true ->
        valueTree(rest)
    end
  end

  defp flow(item, _, "A") do
    item
  end

  defp flow(_, _, "R") do
    :rejected
  end

  defp flow(item, map, {cond, {ifTrue, ifFalse}}) do
    cond = isCondTrue(cond, item)

    newWorkflow = nextWorkflow(cond, ifTrue, ifFalse)

    flow(item, map, newWorkflow)
  end

  defp flow(item, map, workflow) do
    {cond, {ifTrue, ifFalse}} = map[workflow]
    cond = isCondTrue(cond, item)

    newWorkflow = nextWorkflow(cond, ifTrue, ifFalse)

    flow(item, map, newWorkflow)
  end

  defp isCondTrue(<<"x", rest::binary>>, {x, _, _, _}) do
    cond do
      String.first(rest) == ">" ->
        x > String.to_integer(String.slice(rest, 1..-1))

      true ->
        x < String.to_integer(String.slice(rest, 1..-1))
    end
  end

  defp isCondTrue(<<"m", rest::binary>>, {_, m, _, _}) do
    cond do
      String.first(rest) == ">" ->
        m > String.to_integer(String.slice(rest, 1..-1))

      true ->
        m < String.to_integer(String.slice(rest, 1..-1))
    end
  end

  defp isCondTrue(<<"a", rest::binary>>, {_, _, a, _}) do
    cond do
      String.first(rest) == ">" ->
        a > String.to_integer(String.slice(rest, 1..-1))

      true ->
        a < String.to_integer(String.slice(rest, 1..-1))
    end
  end

  defp isCondTrue(<<"s", rest::binary>>, {_, _, _, s}) do
    cond do
      String.first(rest) == ">" ->
        s > String.to_integer(String.slice(rest, 1..-1))

      true ->
        s < String.to_integer(String.slice(rest, 1..-1))
    end
  end

  defp nextWorkflow(cond, ifTrue, ifFalse) do
    cond do
      cond ->
        ifTrue

      true ->
        ifFalse
    end
  end
end
