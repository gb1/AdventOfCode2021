defmodule Day5 do
  def solve do
    # input = """
    # 0,9 -> 5,9
    # 8,0 -> 0,8
    # 9,4 -> 3,4
    # 2,2 -> 2,1
    # 7,0 -> 7,4
    # 6,4 -> 2,0
    # 0,9 -> 2,9
    # 3,4 -> 1,4
    # 0,0 -> 8,8
    # 5,5 -> 8,2
    # """

    input = File.read!("inputs/day5_input.txt")

    part1 =
      input
      |> String.split("\n", trim: true)
      |> make_points()
      |> only_horiz_and_vertical()
      |> make_lines()
      |> List.flatten()
      |> map_points(%{})
      |> count_2_or_more_points()
      |> length()

    IO.puts("Part 1: #{part1}")

    part2 =
      input
      |> String.split("\n", trim: true)
      |> make_points()
      |> make_all_lines()
      |> List.flatten()
      |> map_points(%{})
      |> count_2_or_more_points()
      |> length()

    IO.puts("Part 2: #{part2}")
  end

  def make_all_lines(points) do
    points
    |> Enum.map(fn {{start_x, start_y}, {finish_x, finish_y}} ->
      make_line({start_x, start_y}, {finish_x, finish_y}, [], {start_x, start_y})
    end)
  end

  # source and destination are the same so we are done!
  def make_line({x, y}, {x, y}, points, source), do: [source | points]

  def make_line({source_x, source_y}, {target_x, target_y}, points, source) do
    next_x =
      cond do
        source_x > target_x -> source_x - 1
        source_x < target_x -> source_x + 1
        true -> source_x
      end

    next_y =
      cond do
        source_y > target_y -> source_y - 1
        source_y < target_y -> source_y + 1
        true -> source_y
      end

    make_line(
      {next_x, next_y},
      {target_x, target_y},
      [{next_x, next_y} | points],
      source
    )
  end

  def map_points([], map), do: map

  def map_points([point | tail], map) do
    map_points(
      tail,
      Map.update(map, point, 1, fn value -> value + 1 end)
    )
  end

  def count_2_or_more_points(map) do
    map
    |> Enum.filter(fn {_key, value} ->
      value >= 2
    end)
  end

  def make_points(lines) do
    lines
    |> Enum.map(fn x ->
      [start, finish] = String.split(x, " -> ")
      [start_x, start_y] = String.split(start, ",")
      [finish_x, finish_y] = String.split(finish, ",")

      {{int(start_x), int(start_y)}, {int(finish_x), int(finish_y)}}
    end)
  end

  def only_horiz_and_vertical(points) do
    points
    |> Enum.filter(fn {{start_x, start_y}, {finish_x, finish_y}} ->
      start_x == finish_x or start_y == finish_y
    end)
  end

  def make_lines(points) do
    points
    |> Enum.map(fn {{start_x, start_y}, {finish_x, finish_y}} ->
      for x <- start_x..finish_x do
        for y <- start_y..finish_y do
          {x, y}
        end
      end
    end)
  end

  def int(s), do: String.to_integer(s)
end
