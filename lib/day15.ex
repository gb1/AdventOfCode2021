defmodule Day15 do
  def solve do
    input = """
    1163751742
    1381373672
    2136511328
    3694931569
    7463417111
    1319128137
    1359912421
    3125421639
    1293138521
    2311944581
    """

    lines =
      input
      |> String.split("\n", trim: true)

    for {line, row} <- Enum.with_index(lines),
        {number, col} <- Enum.with_index(String.split(line, "", trim: true)),
        into: %{} do
      {{row, col}, String.to_integer(number)}
    end
  end
end
