defmodule Day9 do
  def solve do
    input = """
    2199943210
    3987894921
    9856789892
    8767896789
    9899965678
    """

    input = File.read!("inputs/day9_input.txt")

    part1 =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        String.split(line, "", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
      |> build_map(0, %{})
      |> find_low_points()
      |> Enum.sum()

    IO.puts("Part 1: #{part1}")

    map =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        String.split(line, "", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
      |> build_map(0, %{})

    points =
      map
      |> Enum.reject(fn {_key, value} ->
        value == 9
      end)
      |> Enum.map(fn {point, _} ->
        point
      end)

    # cache points we have seen already
    Agent.start_link(fn -> [] end, name: :seen)

    part2 =
      points
      |> Enum.map(fn point ->
        build_basin_for_point(
          [point],
          adjacents(points, map, %{}),
          []
        )
      end)
      |> Enum.sort_by(&length(&1), :desc)
      |> Enum.map(&length(&1))
      |> Enum.take(3)
      |> Enum.product()

    IO.puts("Part 2: #{part2}")
  end

  def build_basin_for_point([], _adj, visited), do: visited

  def build_basin_for_point([point | queue], adj, visited) do
    if Enum.member?(visited, point) or Agent.get(:seen, &Enum.member?(&1, point)) do
      build_basin_for_point(queue, adj, visited)
    else
      Agent.update(:seen, &[point | &1])
      visited = [point | visited]
      queue = queue ++ (Map.get(adj, point) -- visited)
      build_basin_for_point(queue, adj, visited)
    end
  end

  def adjacents([], _map, adj), do: adj

  def adjacents([point | tail], map, adj) do
    adjacents(tail, map, Map.put(adj, point, get_adjacent_points(point, map)))
  end

  def get_adjacent_points({x, y}, map) do
    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
    |> Enum.filter(fn point ->
      Map.get(map, point) != nil and Map.get(map, point) != 9
    end)
  end

  ## PART 1

  def find_low_points(map) do
    Enum.reduce(map, [], fn {key, value}, acc ->
      adjacents = get_adjacents(key, map)

      if Enum.any?(adjacents, &(&1 <= value)) do
        acc
      else
        [value + 1 | acc]
      end
    end)
  end

  def get_adjacents({x, y}, map) do
    [
      Map.get(map, {x + 1, y}),
      Map.get(map, {x - 1, y}),
      Map.get(map, {x, y + 1}),
      Map.get(map, {x, y - 1})
    ]
    |> Enum.filter(& &1)
  end

  def build_map([], _y, map), do: map

  def build_map([line | lines], y, map) do
    map = build_row(line, 0, y, map)

    build_map(lines, y + 1, map)
  end

  def build_row([], _x, _y, map), do: map

  def build_row([head | tail], x, y, map) do
    build_row(tail, x + 1, y, Map.put(map, {x, y}, head))
  end
end
