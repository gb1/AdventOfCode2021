defmodule Day11 do
  @rows 0..9
  @lines 0..9

  def solve do
    input = """
    4438624262
    6263251864
    2618812434
    2134264565
    1815131247
    2612457325
    8585767584
    7217134556
    2825456563
    8248473584
    """

    grid =
      input
      |> build_grid()

    part1 =
      1..100
      |> Enum.map_reduce(grid, fn _, grid ->
        {grid, flashes} = step(Map.keys(grid), grid, MapSet.new())
        {flashes, grid}
      end)
      |> elem(0)
      |> Enum.sum()

    IO.puts("Part 1: #{part1}")

    part2 =
      1..1000
      |> Enum.reduce_while(grid, fn index, grid ->
        {grid, flashes} = step(Map.keys(grid), grid, MapSet.new())

        if flashes == 100 do
          {:halt, index}
        else
          {:cont, grid}
        end
      end)
  end

  def build_grid(input) do
    lines = String.split(input, "\n", trim: true)

    for {line, row} <- Enum.with_index(lines),
        {number, col} <- Enum.with_index(String.split(line, "", trim: true)),
        into: %{} do
      {{row, col}, String.to_integer(number)}
    end
  end

  def step([], grid, flashed) do
    {grid, MapSet.size(flashed)}
  end

  def step([{row, col} | points], grid, flashed) do
    value = grid[{row, col}]

    cond do
      is_nil(value) or {row, col} in flashed ->
        step(points, grid, flashed)

      value >= 9 ->
        # add any neighbour points to flash
        points = get_neighbours({row, col}, points)
        step(points, Map.put(grid, {row, col}, 0), MapSet.put(flashed, {row, col}))

      true ->
        step(points, Map.put(grid, {row, col}, value + 1), flashed)
    end
  end

  def print_grid(grid) do
    IO.puts("______________________")

    Enum.each(@lines, fn row ->
      line =
        for col <- @rows do
          grid[{row, col}]
        end

      IO.puts(Enum.join(line, " | "))
    end)

    IO.puts("----------------------")
  end

  def get_neighbours({row, col}, points) do
    [
      {row - 1, col - 1},
      {row - 1, col},
      {row - 1, col + 1},
      {row, col - 1},
      {row, col + 1},
      {row + 1, col - 1},
      {row + 1, col},
      {row + 1, col + 1}
      | points
    ]
  end
end
