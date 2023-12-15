defmodule Aoc2023.Day13Part1 do
  def run() do
    File.read!("lib/day13/input13.txt")
    |> processInput()
    |> Enum.sum()
  end

  defp processInput(file) do
    String.split(file, "\n\n", trim: true)
    |> Enum.map(fn pattern ->
      rows = String.split(pattern, "\n", trim: true)

      numOfRowsAboveMirror = mirroredRows(rows)

      cond do
        numOfRowsAboveMirror !== 0 ->
          numOfRowsAboveMirror * 100

        true ->
          matrix = Enum.map(rows, fn pos -> String.split(pos, "", trim: true) end)
          transposedPattern = Matrix.transpose(matrix)
          mirroredRows(transposedPattern)
      end
    end)
  end

  defp mirroredRows(rows) do
    mirroredRows =
      Enum.reduce(0..(length(rows) - 2), [], fn i, acc ->
        cond do
          Enum.at(rows, i) == Enum.at(rows, i + 1) ->
            [i] ++ acc

          true ->
            acc
        end
      end)
      |> Enum.map(fn pos ->
        numOfRows = Enum.count(rows)
        rowMiddle = numOfRows / 2

        cond do
          rowMiddle - 1 < pos -> {{pos - (numOfRows - pos - 2), pos}, {pos + 1, numOfRows - 1}}
          true -> {{0, pos}, {pos + 1, pos * 2 + 1}}
        end
      end)
      |> Enum.map(fn {{topStart, topEnd}, {buttomStart, buttomEnd}} ->
        top = Enum.slice(rows, topStart..topEnd)
        buttom = Enum.reverse(Enum.slice(rows, buttomStart..buttomEnd))

        cond do
          top == buttom -> buttomStart
          true -> 0
        end
      end)

    cond do
      Enum.sum(mirroredRows) !== 0 -> Enum.sum(mirroredRows)
      true -> 0
    end
  end
end

# ------------CREDIT GOES TO------------
# J David Eisenberg
# <jdavid.eisenberg@gmail.com>
# https://langintro.com/elixir/article2/
# --------------------------------------
defmodule Matrix do
  def transpose(m) do
    attach_row(m, [])
  end

  def attach_row([], result) do
    reverse_rows(result, [])
  end

  def attach_row(row_list, result) do
    [first_row | other_rows] = row_list
    new_result = make_column(first_row, result, [])
    attach_row(other_rows, new_result)
  end

  def make_column([], _, new) do
    Enum.reverse(new)
  end

  def make_column(row, [], accumulator) do
    [row_head | row_tail] = row
    make_column(row_tail, [], [[row_head] | accumulator])
  end

  def make_column(row, result, accumulator) do
    [row_head | row_tail] = row
    [result_head | result_tail] = result
    make_column(row_tail, result_tail, [[row_head | result_head] | accumulator])
  end

  def reverse_rows([], result) do
    Enum.reverse(result)
  end

  def reverse_rows([first | others], result) do
    reverse_rows(others, [Enum.reverse(first) | result])
  end
end
